//
//  WriteIssuerFilesTask.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/20/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

@available (iOS 13.0, *)
public class WriteIssuerFilesTask: CardSessionRunnable {
	public typealias CommandResponse = WriteFilesResponse
	
	private let files: [Data]
	private let issuerKeys: KeyPair
	private let writeSettings: Set<WriteFilesSettings>
	
	public init(files: [Data], issuerKeys: KeyPair, writeSettings: Set<WriteFilesSettings>) {
		self.files = files
		self.issuerKeys = issuerKeys
		self.writeSettings = writeSettings
	}
	
	public func run(in session: CardSession, completion: @escaping CompletionResult<WriteFilesResponse>) {
		readFilesCounter(session: session, completion: completion)
	}
	
	private func readFilesCounter(session: CardSession, completion: @escaping CompletionResult<WriteFilesResponse>) {
		let readFiles = ReadFileCommand(fileIndex: 0, readPrivateFiles: false)
		readFiles.run(in: session) { (result) in
			switch result {
			case .success(let response):
				self.writeFiles(readResponse: response, session: session, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func writeFiles(readResponse: ReadFileResponse, session: CardSession, completion: @escaping CompletionResult<WriteFilesResponse>) {
		guard let cardId = session.environment.card?.cardId else {
			completion(.failure(.cardError))
			return
		}
		var counter = readResponse.fileDataCounter ?? 0
		var filesToWrite = [DataToWrite]()
		files.forEach {
			counter += 1
			let hashes = FileHashHelper.prepareHash(for: cardId, fileData: $0, fileCounter: counter, privateKey: issuerKeys.privateKey)
			guard
				let starting = hashes.startingSignature,
				let finalizing = hashes.finalizingSignature
			else { return }
			filesToWrite.append(
				FileDataProtectedBySignature(
					data: $0,
					startingSignature: starting,
					finalizingSignature: finalizing,
					counter: counter,
					issuerPublicKey: issuerKeys.publicKey)
			)
		}
		let task = WriteFilesTask(files: filesToWrite, settings: writeSettings)
		task.run(in: session, completion: completion)
	}
}
