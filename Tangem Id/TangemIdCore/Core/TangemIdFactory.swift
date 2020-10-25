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
	private let tangemSdk: TangemSdk
	
	public init(tangemSdk: TangemSdk) {
		self.tangemSdk = tangemSdk
	}
	
	func createIssuerManager() -> TangemIssuerManager {
		TangemIdSdk(executioner: TangemIdIssuer(tangemSdk: tangemSdk, credentialCreator: factory.makeCreator(.demo)))
	}
	
	func createVerifierManager() -> TangemVerifierManager {
		TangemIdSdk(executioner: TangemIdVerifier(tangemSdk: tangemSdk, viewCredentialFactory: DemoCredentialFactory(imageHasher: JpegSha3ImageHasher(), credentialCreator: factory.makeCreator(.demo))))
	}
	
	func createHolderManager() -> TangemHolderManager {
		TangemIdSdk(executioner: TangemIdHolder(tangemSdk: tangemSdk, viewCredentialFactory: DemoCredentialFactory(imageHasher: JpegSha3ImageHasher(), credentialCreator: factory.makeCreator(.demo))))
	}
	
}
