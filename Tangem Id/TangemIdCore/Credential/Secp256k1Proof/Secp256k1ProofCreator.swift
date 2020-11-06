//
//  Secp256k1ProofCreator.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/5/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

typealias ProofVerificationHash = Data

protocol Secp256k1ProofCreatorType {
	func createProof(for credential: VerifiableCredential, issuerWalletAddress: String) throws -> (Secp256k1Proof, ProofVerificationHash)
}

struct Secp256k1ProofCreator: Secp256k1ProofCreatorType {
	
	private func calculateVerificationHash(for creds: VerifiableCredential, proofSettings: inout Secp256k1ProofSettings) throws -> ProofVerificationHash {
		let jsonDecoder = JSONEncoder()
		proofSettings.context = creds.context
		proofSettings.verificationMethod = creds.issuer + IdConstants.ownerSuffix
		
		var credsDict = creds.toStringDict() as [String: Any]
		credsDict.removeValue(forKey: "proof")
		
		let proofData = try jsonDecoder.encode(proofSettings)
		let credsData = try NSKeyedArchiver.archivedData(withRootObject: credsDict, requiringSecureCoding: false)
		
		let proofHash = proofData.sha256()
		let credsHash = credsData.sha256()
		return proofHash + credsHash
	}
	
	func createProof(for credential: VerifiableCredential, issuerWalletAddress: String) throws -> (Secp256k1Proof, ProofVerificationHash) {
		let emptyProof = Secp256k1Proof(verificationMethod: IdConstants.didPrefix + issuerWalletAddress + IdConstants.ownerSuffix)
		var proofSettings = Secp256k1ProofSettings.default
		var verificationHash = try calculateVerificationHash(for: credential, proofSettings: &proofSettings)
		verificationHash = verificationHash.sha256()
		return (emptyProof, verificationHash)
	}
}
