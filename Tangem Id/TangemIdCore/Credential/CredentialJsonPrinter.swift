//
//  CredentialJsonPrinter.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

protocol CredentialJsonPrinter {
	func createJson(for creds: [VerifiableCredential], completion: (JsonCredentialsResult) -> Void)
}

extension CredentialJsonPrinter {
	func createJson(for creds: [VerifiableCredential], completion: (JsonCredentialsResult) -> Void) {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(.iso8601WithSlashes)
		encoder.outputFormatting = .prettyPrinted
		do {
			let encodedData = try encoder.encode(creds)
			guard let string = String(data: encodedData, encoding: .utf8) else {
				completion(.failure(.failedToCreateJsonRepresentation))
				return
			}
			completion(.success(string))
		} catch {
			completion(.failure(.failedToCreateJsonRepresentation))
		}
	}
}
