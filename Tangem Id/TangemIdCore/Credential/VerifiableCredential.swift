//
//  VerifiableCredential.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

struct PersonalInformationCredential: Codable {
	let id: String
	let givenName: String
	let familyName: String
	let gender: String
	let born: String
	let photoHash: String
}

enum VerifiableCredentialType: String, Codable, CaseIterable {
	case VerifiableCredential, TangemEthCredential, TangemPersonalInformationCredential, TangemSsnCredential, TangemAgeOver21Credential
}

struct CredentialProof: Codable {
	let verificationMethod: String
	let jws: String
}

struct VerifiableCredential<Subject: Codable>: Codable {
	let context: [String]
	let type: [VerifiableCredentialType]
	let credentialSubject: Subject
	let issuer: String
	let issuanceDate: String
	let validFrom: Date?
	let ethCredentialStatus: String
	let proof: CredentialProof
	
	private enum CodingKeys: String, CodingKey {
		case context = "@context"
		case type, credentialSubject, issuer, issuanceDate, ethCredentialStatus, proof, validFrom
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
