//
//  CredentialsController.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/5/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import SwiftCBOR

protocol CredentialsControllerType: class {
	func signCredentials(for input: CredentialInput, subjectEthAddress: String, completion: @escaping EmptyResponse)
	func writeCredentialsToCard(completion: @escaping EmptyResponse)
}

class DemoCredentialsController {
	
	private let tangemSdk: TangemSdk
	private let credentialCreator: CredentialCreator
	private let proofCreator: Secp256k1ProofCreatorType
	private let issuerCardId: String
	private let issuerWalletAddress: String
	
	private let signatureSize: Int = 64
	
	private var signedCreds: [VerifiableCredential] = []
	
	internal init(tangemSdk: TangemSdk, credentialCreator: CredentialCreator, issuerCardId: String, issuerWalletAddress: String, proofCreator: Secp256k1ProofCreatorType) {
		self.tangemSdk = tangemSdk
		self.credentialCreator = credentialCreator
		self.issuerCardId = issuerCardId
		self.issuerWalletAddress = issuerWalletAddress
		self.proofCreator = proofCreator
	}
	
	private func processSignedSignatures(_ signature: Data, numberOfCreds: Int) -> [Data] {
		guard signature.count == signatureSize * numberOfCreds else { return [] }
		var signatures = [Data]()
		for i in 0..<numberOfCreds {
			signatures.append(signature.subdata(in: (i * signatureSize)..<((i + 1) * signatureSize)))
		}
		return signatures
	}
	
}

extension DemoCredentialsController: CredentialsControllerType {
	func signCredentials(for input: CredentialInput, subjectEthAddress: String, completion: @escaping EmptyResponse) {
		do {
			let creds = try credentialCreator.createCredentialsToSign(issuerDidAddress: issuerWalletAddress,
																	  input: input,
																	  holderEthereumAddress: subjectEthAddress)
			var hashesToSign = [Data]()
			try creds.forEach {
				let proofHashTuplet = try proofCreator.createProof(for: $0, issuerWalletAddress: issuerWalletAddress)
				$0.proof = proofHashTuplet.0
				hashesToSign.append(proofHashTuplet.1)
			}
			
			tangemSdk.sign(hashes: hashesToSign, cardId: issuerCardId, initialMessage: Message(header: IdLocalization.Common.scanIssuerCard, body: nil)) { [weak self] (result) in
				guard let self = self else { return }
				switch result {
				case .success(let signResponse):
					let signedCreds = signResponse.signature
					let signedSignatures = self.processSignedSignatures(signedCreds, numberOfCreds: creds.count)
					for (cred, signedSignature) in zip(creds, signedSignatures) {
						guard let str = String(data: signedSignature, encoding: .utf8) else { continue }
						cred.proof?.jws = str
					}
					self.signedCreds = creds
					completion(.success(()))
				case .failure(let tangemError):
					completion(.failure(.cardSdkError(sdkError: tangemError.localizedDescription)))
				}
			}
		} catch {
			completion(.failure(.credentialSigningError(error: error.localizedDescription)))
		}
	}
	
	func writeCredentialsToCard(completion: @escaping EmptyResponse) {
		let filesToWrite = signedCreds.map {
			$0.cborData()
		}.map {
			FileDataProtectedByPasscode(data: $0)
		}
		
		tangemSdk.writeFiles(files: filesToWrite, writeFilesSettings: [.overwriteAllFiles]) { (result) in
			switch result {
			case .success(let filesResponse):
				print(filesResponse)
				completion(.success(()))
			case .failure(let error):
				print("Failed to write files to card")
				completion(.failure(.cardSdkError(sdkError: error.localizedDescription)))
			}
		}
	}
}
