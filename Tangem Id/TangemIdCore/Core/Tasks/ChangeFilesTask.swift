//
//  ChangeFilesTask.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/25/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

@available (iOS 13.0, *)
public class ChangeFilesTask: CardSessionRunnable {
	public typealias CommandResponse = SimpleResponse
	
	private let filesToDelete: [File]
	private let filesToUpdateSettings: [File]
	
	public init(filesToDelete: [File], filesToUpdateSettings: [File]) {
		self.filesToDelete = filesToDelete
		self.filesToUpdateSettings = filesToUpdateSettings
	}
	
	public func run(in session: CardSession, completion: @escaping CompletionResult<SimpleResponse>) {
		let changeSettingsTask = ChangeFilesSettingsTask(files: filesToUpdateSettings)
		changeSettingsTask.run(in: session) { (result) in
			switch result {
			case .success:
				self.deleteFiles(in: session, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func deleteFiles(in session: CardSession, completion: @escaping CompletionResult<SimpleResponse>) {
		let deleteFilesTask = DeleteFilesTask(filesToDelete: filesToDelete.map { $0.fileIndex })
		deleteFilesTask.run(in: session, completion: completion)
	}
}
