//
//  Secp256k1Proof.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/4/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import SwiftCBOR

class Secp256k1Proof: Codable, DictConvertible {
	
	var verificationMethod: String
	var challenge: String?
	var type: String
	var proofPurpose: String
	var created: String
	var jws: String?
	
	private enum CodingKeys: String, CodingKey {
		case verificationMethod, challenge, type, proofPurpose, created, jws
	}

	internal init(verificationMethod: String, challenge: String? = nil, jws: String? = nil) {
		self.verificationMethod = verificationMethod
		self.challenge = challenge
		self.type = "EcdsaSecp256k1Signature2019"
		self.proofPurpose = "assertionMethod"
		self.created = Date().iso8601withFractionalSeconds
		self.jws = jws
	}
	
	func cbor() -> CBOR {
		var map = CBOR.map([
			CodingKeys.verificationMethod.rawValue.cbor(): verificationMethod.cbor(),
			CodingKeys.type.rawValue.cbor(): type.cbor(),
			CodingKeys.proofPurpose.rawValue.cbor(): proofPurpose.cbor(),
			CodingKeys.created.rawValue.cbor(): created.cbor()
		])
		if let challenge = challenge {
			map[CodingKeys.challenge.rawValue.cbor()] = challenge.cbor()
		}
		if let jws = jws {
			map[CodingKeys.jws.rawValue.cbor()] = jws.cbor()
		}
		return map
	}
	
}
