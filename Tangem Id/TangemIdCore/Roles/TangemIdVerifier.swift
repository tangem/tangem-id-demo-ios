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
	private let viewCredentialFactory: ViewCredentialFactory
	
	private var readCredentials: [VerifiableCredential] = []
	private var viewCredentials: VerifierViewCredentials?

	init(tangemSdk: TangemSdk, viewCredentialFactory: ViewCredentialFactory) {
		self.tangemSdk = tangemSdk
		self.viewCredentialFactory = viewCredentialFactory
	}

	var executionerInfo: RoleInfo {
		VerifierRoleInfo()
	}

	func execute(action: VerifierAction) {
		switch action {
		case .readHoldersCredentials(let completion):
			readFiles(completion: completion)
		case .showCredentialsAsJson(let completion):
			createJson(for: readCredentials, completion: completion)
		}
	}

	private func readFiles(completion: @escaping CompletionResult<VerifierViewCredentials>) {
		let task = ReadHolderCardTask(settings: .init(readPrivateFiles: false), role: .verifier)
		tangemSdk.startSession(with: task, initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil)) { (result) in
			switch result {
			case .success(let response):
				self.convertFilesToCreds(response.files, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func convertFilesToCreds(_ files: [File], completion: @escaping CompletionResult<VerifierViewCredentials>) {
		let factoryResult = viewCredentialFactory.createVerifierViewCreds(files)
		switch factoryResult {
		case .success(let tuplet):
			self.readCredentials = tuplet.creds
			self.viewCredentials = tuplet.viewCreds
			completion(.success(tuplet.viewCreds))
		case .failure(let error):
			completion(.failure(.underlying(error: error)))
		}
	}
	
 }

extension TangemIdVerifier: CredentialJsonPrinter { }
