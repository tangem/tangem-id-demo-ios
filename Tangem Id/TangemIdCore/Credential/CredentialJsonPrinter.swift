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
		var json = ""
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(.iso8601WithSlashes)
		encoder.outputFormatting = .prettyPrinted
		creds.forEach {
			do {
				let encodedData = try encoder.encode($0)
				guard let string = String(data: encodedData, encoding: .utf8) else {
					completion(.failure(.failedToCreateJsonRepresentation))
					return
				}
				json.append(string)
				json.append("\n")
			} catch {
				completion(.failure(.failedToCreateJsonRepresentation))
			}
		}
		completion(.success(json))
	}
}
