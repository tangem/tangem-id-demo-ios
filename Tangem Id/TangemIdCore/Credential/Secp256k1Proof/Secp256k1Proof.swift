//
//  Secp256k1Proof.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/4/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

class Secp256k1Proof: Codable, DictConvertible {
	
	internal init(verificationMethod: String, challenge: String? = nil, jws: String? = nil) {
		self.verificationMethod = verificationMethod
		self.challenge = challenge
		self.type = "EcdsaSecp256k1Signature2019"
		self.proofPurpose = "assertionMethod"
		self.created = Date().iso8601withFractionalSeconds
		self.jws = jws
	}
	
	var verificationMethod: String
	var challenge: String?
	var type: String
	var proofPurpose: String
	var created: String
	var jws: String?
}
