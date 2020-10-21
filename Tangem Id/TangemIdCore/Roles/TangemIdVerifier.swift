//
//  TangemIdVerifier.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import SwiftCBOR

typealias TangemVerifierManager = TangemIdSdk<TangemIdVerifier>
 
 final class TangemIdVerifier: ActionExecutioner {

	private let tangemSdk: TangemSdk
	private let credentialCreator: CredentialCreator
	
	private var readCredentials: [VerifiableCredential] = []

	init(tangemSdk: TangemSdk, credentialCreator: CredentialCreator) {
		self.tangemSdk = tangemSdk
		self.credentialCreator = credentialCreator
	}

	var executionerInfo: RoleInfo {
		VerifierRoleInfo()
	}

	func execute(action: VerifierAction) {
		switch action {
		case .readHoldersCredentials(let completion):
			readFiles(completion: completion)
		case .showCredentialsAsJson(_):
//			readFiles()
			break
		}
	}

	private func readFiles(completion: @escaping CompletionResult<[VerifiableCredential]>) {
		tangemSdk.readFiles(readSettings: ReadFilesTaskSettings(readPrivateFiles: false)) { (result) in
			switch result {
			case .success(let response):
				self.convertFilesToCreds(response.files, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func convertFilesToCreds(_ files: [File], completion: @escaping CompletionResult<[VerifiableCredential]>) {
		let readCredentials = credentialCreator.createCredentials(from: files)
		self.readCredentials = readCredentials
		completion(.success(readCredentials))
	}
 }

extension TangemIdVerifier: CredentialJsonPrinter { }
