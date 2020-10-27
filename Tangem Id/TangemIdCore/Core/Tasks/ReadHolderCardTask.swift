//
//  ReadHolderCardTask.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/23/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

@available (iOS 13.0, *)
public struct ReadHolderCardTaskResponse: ResponseCodable {
	public let cardId: String
	public let walletPublicKey: Data
	public let files: [File]
}

@available (iOS 13.0, *)
public class ReadHolderCardTask: CardSessionRunnable {
	public typealias CommandResponse = ReadHolderCardTaskResponse
	
	public init(settings: ReadFilesTaskSettings, role: Role) {
		self.settings = settings
		self.role = role
	}
	
	private let settings: ReadFilesTaskSettings
	private let role: Role
	
	public func run(in session: CardSession, completion: @escaping CompletionResult<ReadHolderCardTaskResponse>) {
		guard isValidCard(for: role, in: session, shouldStopSessionIfNotValid: true) else {
			completion(.failure(.underlying(error: TangemIdError.cancelledWithoutError)))
			return
		}
		
		let readFilesTask = ReadFilesTask(settings: settings)
		readFilesTask.run(in: session) { (result) in
			switch result {
			case .success(let response):
				completion(.success(ReadHolderCardTaskResponse(cardId: session.environment.card?.cardId ?? "",
															   walletPublicKey: session.environment.card?.walletPublicKey ?? Data(),
															   files: response.files)))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}

extension ReadHolderCardTask: RoleCardTypeChecker { }
