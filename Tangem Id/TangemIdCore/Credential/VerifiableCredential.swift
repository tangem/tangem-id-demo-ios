//
//  VerifiableCredential.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import SwiftCBOR

protocol DictConvertible { }

extension DictConvertible {
	func toStringDict() -> [String: String] {
		var dict = [String: String]()
		let mirror = Mirror(reflecting: self)
		for child in mirror.children {
			guard
				let key = child.label,
				case Optional<Any>.some = child.value
			else { continue }
			let value = "\(child.value)"
			dict[key] = value
		}
		return dict
	}
	
	func toAnyDict() -> [String: Any] {
		var dict = [String: Any]()
		let mirror = Mirror(reflecting: self)
		for child in mirror.children {
			guard
				let key = child.label,
				case Optional<Any>.some = child.value
			else { continue }
			let value = child.value
			dict[key] = value
		}
		return dict
	}
}

struct PersonalInformationCredential: Codable, DictConvertible {
	internal init(id: String, givenName: String, familyName: String, gender: String, born: String, photoHash: String) {
		self.id = id
		self.givenName = givenName
		self.familyName = familyName
		self.gender = gender
		self.born = born
		self.photoHash = photoHash
	}
	
	init(id: String, input: CredentialInput, photoHash: String) {
		let formatter = DateFormatter.monthDayYear
		self.init(id: id, givenName: input.name, familyName: input.surname, gender: input.gender, born: formatter.string(from: input.dateOfBirth), photoHash: photoHash)
	}
	
	enum CodingKeys: String, CodingKey {
		case id, givenName, familyName, gender, born, photoHash
	}
	
	let id: String
	let givenName: String
	let familyName: String
	let gender: String
	let born: String
	let photoHash: String
}

struct PhotoCredentialSubject: DictConvertible {
	let id: String
	let photo: String
	
	enum CodingKeys: String, CodingKey {
		case id, photo
	}
}

struct SsnCredentialSubject: DictConvertible {
	let id: String
	let ssn: String
	let photoHash: String
	
	enum CodingKeys: String, CodingKey {
		case id, ssn, photoHash
	}
}

struct AgeOver21CredentialSubject: DictConvertible {
	let id: String
	let photoHash: String
	
	enum CodingKeys: String, CodingKey {
		case id, photoHash
	}
}

enum CovidStatus: String {
	case negative, positive
}

struct CovidCredentialSubject: DictConvertible {
	let id: String
	let result: CovidStatus
	
	enum CodingKeys: String, CodingKey {
		case id, result
	}
}


enum VerifiableCredentialType: String, Codable, CaseIterable, CBOREncodable {
	case VerifiableCredential, TangemEthCredential, TangemPhotoCredential, TangemPersonalInformationCredential, TangemSsnCredential, TangemAgeOver21Credential, TangemCovidCredential
	
	func encode() -> [UInt8] {
		self.rawValue.encode()
	}
}

class VerifiableCredential: Codable, DictConvertible {
	let context: [String]
	let type: [VerifiableCredentialType]
	let credentialSubject: [String: String]
	let issuer: String
	let issuanceDate: String
	var validFrom: Date? = nil
	var ethCredentialStatus: String? = nil
	var proof: Secp256k1Proof? = nil
	
	private static let validFromFormatter: DateFormatter = .iso8601WithSlashes
	
	private enum CodingKeys: String, CodingKey {
		case context = "@context"
		case type, credentialSubject, issuer, issuanceDate, ethCredentialStatus, proof, validFrom
	}
	
	public init(context: [String], type: [VerifiableCredentialType], credentialSubject: [String: String], issuer: String, issuanceDate: String) {
		self.context = context
		self.type = type
		self.credentialSubject = credentialSubject
		self.issuer = issuer
		self.issuanceDate = issuanceDate
	}
	
	public init(cbor: CBOR) throws {
		guard
			case let .map(dict) = cbor,
			case let .array(contextCbor) = dict[CodingKeys.context.rawValue.cbor()],
			case let .array(typeCbor) = dict[CodingKeys.type.rawValue.cbor()],
			let subjectCbor = dict[CodingKeys.credentialSubject.rawValue.cbor()],
			case let .map(subjectMap) = subjectCbor,
			case let .utf8String(issuer) = dict[CodingKeys.issuer.rawValue.cbor()],
			case let .utf8String(issuanceDate) = dict[CodingKeys.issuanceDate.rawValue.cbor()]
			else {
			throw TangemIdError.notValidCborData
		}
		if case let .utf8String(validFromString) = dict[CodingKeys.validFrom.rawValue.cbor()],
		   let validFromDate = VerifiableCredential.validFromFormatter.date(from: validFromString) {
			validFrom = validFromDate
		}
		if let proofCborDict = dict[CodingKeys.proof.rawValue.cbor()] {
			self.proof = try Secp256k1Proof(cbor: proofCborDict)
		}
		if case let .utf8String(ethCredentialStatus) = dict[CodingKeys.ethCredentialStatus.rawValue.cbor()] {
			self.ethCredentialStatus = ethCredentialStatus
		}
		context = try contextCbor.map {
			guard case let .utf8String(contextStr) = $0 else {
				throw TangemIdError.notValidCborData
			}
			return contextStr
		}
		type = try typeCbor.map {
			guard
				case let .utf8String(typeStr) = $0,
				let type = VerifiableCredentialType(rawValue: typeStr) else {
				throw TangemIdError.notValidCborData
			}
			return type
		}
		var subject = [String: String]()
		try subjectMap.forEach {
			guard
				case let .utf8String(key) = $0.key,
				case let .utf8String(value) = $0.value
			else {
				throw TangemIdError.notValidCborData
			}
			subject[key] = value
		}
		self.credentialSubject = subject
		self.issuer = issuer
		self.issuanceDate = issuanceDate
	}
	
	func cborData() -> Data {
		var map = CBOR.map(
			[
				CodingKeys.context.rawValue.cbor(): context.cborArray(),
				CodingKeys.type.rawValue.cbor(): CBOR.array(type.map { CBOR.utf8String($0.rawValue) }),
				CodingKeys.credentialSubject.rawValue.cbor(): credentialSubject.cborMap(),
				CodingKeys.issuer.rawValue.cbor(): issuer.cbor(),
				CodingKeys.issuanceDate.rawValue.cbor(): issuanceDate.cbor(),
			]
		)
		if let valid = validFrom {
			map[CodingKeys.validFrom.rawValue.cbor()] = CBOR.utf8String(VerifiableCredential.validFromFormatter.string(from: valid))
		}
		if let ethStatus = ethCredentialStatus {
			map[CodingKeys.ethCredentialStatus.rawValue.cbor()] = ethStatus.cbor()
		}
		if let proof = proof {
			map[CodingKeys.proof.rawValue.cbor()] = proof.cbor()
		}
		return Data(map.encode())
	}
	
}
