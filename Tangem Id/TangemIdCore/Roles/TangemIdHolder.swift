//
//  TangemIdHolder.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import BlockchainSdk

typealias TangemHolderManager = TangemIdSdk<TangemIdHolder>

final class TangemIdHolder: ActionExecutioner {
	
	private let tangemSdk: TangemSdk
	private let viewCredentialFactory: ViewCredentialFactory
	
	private let ethBlockchain: Blockchain = .ethereum(testnet: false)
	
	private var cardId: String?
	private var holderAddress: String?
	private var holderViewCredentials: HolderViewCredentials?
	private var holderCredentials: [VerifiableCredential]?
	
	var executionerInfo: RoleInfo {
		HolderRoleInfo()
	}
	
	public init(tangemSdk: TangemSdk, viewCredentialFactory: ViewCredentialFactory) {
		self.tangemSdk = tangemSdk
		self.viewCredentialFactory = viewCredentialFactory
	}
	
	func execute(action: HolderAction) {
		switch action {
		case .scanHolderCredentials(let completion):
			scanHolderCreds(completion: completion)
		case let .saveChanges(filesToDelete, filesToUpdateSettings, completion):
			updateFiles(filesToDelete: filesToDelete, filesToUpdateSettings: filesToUpdateSettings, completion: completion)
		}
	}
	
	private func scanHolderCreds(completion: @escaping CompletionResult<HolderViewCredentials>) {
		let holderReadTask = ReadHolderCardTask(settings: ReadFilesTaskSettings(readPrivateFiles: true))
		tangemSdk.startSession(with: holderReadTask, initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil)) { (result) in
			switch result {
			case .success(let response):
				self.createCreds(response: response, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func createCreds(response: ReadHolderCardTaskResponse, completion: @escaping CompletionResult<HolderViewCredentials>) {
		holderAddress = ethBlockchain.makeAddress(from: response.walletPublicKey)
		var cardId = response.cardId
		self.cardId = cardId
		if cardId.count == 16 {
			let startIndex = cardId.startIndex
			cardId.insert(" ", at: cardId.index(startIndex, offsetBy: 12))
			cardId.insert(" ", at: cardId.index(startIndex, offsetBy: 8))
			cardId.insert(" ", at: cardId.index(startIndex, offsetBy: 4))
		}
		let factoryResult = viewCredentialFactory.createHolderViewCreds(cardId: cardId, files: response.files)
		switch factoryResult {
		case .success(let tuplet):
			holderCredentials = tuplet.creds
			holderViewCredentials = tuplet.viewCreds
			completion(.success(tuplet.viewCreds))
		case .failure(let error):
			completion(.failure(.underlying(error: error)))
		}
	}
	
	private func updateFiles(filesToDelete: [File], filesToUpdateSettings: [File], completion: @escaping CompletionResult<SimpleResponse>) {
		let changeFilesTask = ChangeFilesTask(filesToDelete: filesToDelete, filesToUpdateSettings: filesToUpdateSettings)
		tangemSdk.startSession(with: changeFilesTask, initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil), completion: completion)
	}
	
}
