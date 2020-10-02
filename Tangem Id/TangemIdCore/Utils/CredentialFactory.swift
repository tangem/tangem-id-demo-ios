//
//  CredentialFactory.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

typealias JsonLd = String

protocol CredentialFactory {
	func createCredentials(issuerWallet: String) -> JsonLd
}

struct DemoCredentialFactory: CredentialFactory {
	func createCredentials(issuerWallet: String) -> JsonLd {
		
		return ""
	}
}
