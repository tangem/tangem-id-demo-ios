//
//  Secp256k1ProofSettings.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/5/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

struct Secp256k1ProofSettings: Codable {
	let type: String
	let proofPurpose: String
	let created: String
	
	var verificationMethod: String?
	var context: [String]?
	
	private enum CodingKeys: String, CodingKey {
		case context = "@context"
		case type, proofPurpose, created, verificationMethod
	}
	
	static let `default` = Secp256k1ProofSettings(type: "EcdsaSecp256k1Signature2019",
												  proofPurpose: "assertionMethod",
												  created: Date().iso8601withFractionalSeconds,
												  verificationMethod: "",
												  context: [])
}
