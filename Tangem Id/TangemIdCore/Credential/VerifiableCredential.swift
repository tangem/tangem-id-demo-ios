//
//  VerifiableCredential.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

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

enum VerifiableCredentialType: String, Codable, CaseIterable {
	case VerifiableCredential, TangemEthCredential, TangemPhotoCredential, TangemPersonalInformationCredential, TangemSsnCredential, TangemAgeOver21Credential
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
	
	private enum CodingKeys: String, CodingKey {
		case context = "@context"
		case type, credentialSubject, issuer, issuanceDate, ethCredentialStatus, proof, validFrom
	}
	
	internal init(context: [String], type: [VerifiableCredentialType], credentialSubject: [String : String], issuer: String, issuanceDate: String) {
		self.context = context
		self.type = type
		self.credentialSubject = credentialSubject
		self.issuer = issuer
		self.issuanceDate = issuanceDate
	}
}

//"credentialSubject": {
//			"id": "did:ethr:0x7a1B9E95689edF8576c14Abb30B96BBE4d22dECC",
//			"givenName": "Bird",
//			"familyName": "Birdovich",
//			"gender": "Other",
//			"born": "12/15/3660",
//			"photoHash": "dfNxwzk9P053fKD-fea3ANt-DcHq3wYs7TiIdkEebmE=\n"
//		},
//		"issuer": "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe",
//		"issuanceDate": "2020-10-01T09:56:03.984Z",
//		"ethCredentialStatus": "0xaf920Da90B075Ddbd2b83959F6494A9bb9b6eb0D",
//		"@context": [
//			"https://www.w3.org/2018/credentials/v1"
//		],
//		"type": [
//			"VerifiableCredential",
//			"TangemEthCredential",
//			"TangemPersonalInformationCredential"
//		],
//		"proof": {
//			"verificationMethod": "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe#owner",
//			"jws": "eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ==\n..3qGRRFIzgPC_HfFTYyMHeoax5iYxmD3uv3VTSK7bcAZQKok024PaY1g66zELNyADSg1xWlkPrPjk\nXiQEOeL-6Q==\n"
//		}
