//
//  TangemIdFactory.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

protocol TangemIdFactoryType {
	func createIssuerManager() -> TangemIssuerManager
	func createVerifierManager() -> TangemVerifierManager
}

struct TangemIdFactory: TangemIdFactoryType {
	
	let tangemSdk: TangemSdk
	
	func createIssuerManager() -> TangemIssuerManager {
		TangemIdSdk(executioner: TangemIdIssuer(tangemSdk: tangemSdk, credentialCreatorFactory: CredentialCreatorFactory()))
	}
	
	func createVerifierManager() -> TangemVerifierManager {
		TangemIdSdk(executioner: TangemIdVerifier(tangemSdk: tangemSdk))
	}
	
}
