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
	func createJson(for credential: VerifiableCredential) -> JsonCredentialsResult
}

extension CredentialJsonPrinter {
	func createJson(for creds: [VerifiableCredential], completion: (JsonCredentialsResult) -> Void) {
		var json = ""
		creds.forEach {
			let credJsonResult = createJson(for: $0)
			switch credJsonResult {
			case .success(let credentialJson):
				json.append(credentialJson)
				json.append("\n")
			case .failure(let error):
				print("Failed to create json for creds: \($0)), \(error)")
			}
		}
		if json.isEmpty {
			completion(.failure(.failedToCreateJsonRepresentation))
			return
		}
		completion(.success(json))
	}
	
	func createJson(for credential: VerifiableCredential) -> JsonCredentialsResult {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(.iso8601WithSlashes)
		encoder.outputFormatting = .prettyPrinted
		do {
			let encodedData = try encoder.encode(credential)
			guard let json = String(data: encodedData, encoding: .utf8) else {
				return .failure(.failedToCreateJsonRepresentation)
			}
			return .success(json)
		} catch {
			return .failure(.failedToCreateJsonRepresentation)
		}
	}
}
