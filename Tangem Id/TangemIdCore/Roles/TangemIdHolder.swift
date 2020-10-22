//
//  TangemIdHolder.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

typealias TangemHolderManager = TangemIdSdk<TangemIdHolder>

final class TangemIdHolder: ActionExecutioner {
	
	private let tangemSdk: TangemSdk
	private let credentialCreator: CredentialCreator
	private let imageHasher: ImageHasher
	
	var executionerInfo: RoleInfo {
		HolderRoleInfo()
	}
	
	public init(tangemSdk: TangemSdk, credentialCreator: CredentialCreator, imageHasher: ImageHasher) {
		self.tangemSdk = tangemSdk
		self.credentialCreator = credentialCreator
		self.imageHasher = imageHasher
	}
	
	func execute(action: HolderAction) {
		switch action {
		case .scanHolderCredentials(let completion):
			scanHolderCreds(completion: completion)
		}
	}
	
	private func scanHolderCreds(completion: @escaping CompletionResult<VerifierViewCredentials>) {
		tangemSdk.readFiles(initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil), readSettings: .init(readPrivateFiles: true)) { (result) in
			switch result {
			case .success(let response):
				self.createCreds(response: response, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func createCreds(response: ReadFilesResponse, completion: @escaping CompletionResult<VerifierViewCredentials>) {
		let readCreds = credentialCreator.createCredentials(from: response.files)
	}
	
}
