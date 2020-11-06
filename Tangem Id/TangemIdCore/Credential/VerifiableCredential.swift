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
}

struct SsnCredentialSubject: DictConvertible {
	let id: String
	let ssn: String
	let photoHash: String
}

struct AgeOver21CredentialSubject: DictConvertible {
	let id: String
	let photoHash: String
}

enum VerifiableCredentialType: String, Codable, CaseIterable, CBOREncodable {
	case VerifiableCredential, TangemEthCredential, TangemPhotoCredential, TangemPersonalInformationCredential, TangemSsnCredential, TangemAgeOver21Credential
	
	func encode() -> [UInt8] {
		self.rawValue.encode()
	}
}

class VerifiableCredential: Codable, DictConvertible {
	
	static func == (lhs: VerifiableCredential, rhs: VerifiableCredential) -> Bool {
		lhs.context == rhs.context &&
			lhs.type == rhs.type &&
			lhs.credentialSubject == rhs.credentialSubject &&
			lhs.issuer == rhs.issuer &&
			lhs.issuanceDate == rhs.issuanceDate
	}
	
	
	let context: [String]
	let type: [VerifiableCredentialType]
	let credentialSubject: [String: String]
	let issuer: String
	let issuanceDate: String
	var validFrom: Date? = nil
	var ethCredentialStatus: String? = nil
	var proof: Secp256k1Proof? = nil
	
	private enum CodingKeys: String, CodingKey {
		case context = "@context"
		case type, credentialSubject, issuer, issuanceDate, ethCredentialStatus, proof, validFrom
	}
	
	internal init(context: [String], type: [VerifiableCredentialType], credentialSubject: [String: String], issuer: String, issuanceDate: String) {
		self.context = context
		self.type = type
		self.credentialSubject = credentialSubject
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
			let formatter = DateFormatter.iso8601WithSlashes
			map[CodingKeys.validFrom.rawValue.cbor()] = CBOR.utf8String(formatter.string(from: valid))
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
