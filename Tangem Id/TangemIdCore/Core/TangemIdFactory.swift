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
	func createHolderManager() -> TangemHolderManager
}

struct TangemIdFactory: TangemIdFactoryType {
	
	private let factory = CredentialCreatorFactory()
	
	let tangemSdk: TangemSdk
	
	func createIssuerManager() -> TangemIssuerManager {
		TangemIdSdk(executioner: TangemIdIssuer(tangemSdk: tangemSdk, credentialCreatorFactory: factory))
	}
	
	func createVerifierManager() -> TangemVerifierManager {
		TangemIdSdk(executioner: TangemIdVerifier(tangemSdk: tangemSdk, credentialCreator: factory.makeCreator(.demo), imageHasher: JpegSha3ImageHasher()))
	}
	
	func createHolderManager() -> TangemHolderManager {
		TangemIdSdk(executioner: TangemIdHolder(tangemSdk: tangemSdk, credentialCreator: factory.makeCreator(.demo), imageHasher: JpegSha3ImageHasher()))
	}
	
}
