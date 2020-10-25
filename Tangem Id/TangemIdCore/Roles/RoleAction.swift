//
//  RoleAction.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import Combine

protocol ActionType {}

typealias EmptyResponse = (Result<Void, TangemIdError>) -> Void

enum IssuerAction: ActionType {
	case authorizeAsIssuer(EmptyResponse)
	case getHolderAddress(EmptyResponse)
	case signCredentials(CredentialInput, EmptyResponse)
	case saveCredentialsToCard(EmptyResponse)
	case showCredentialsAsJson((JsonCredentialsResult) -> Void)
}

enum VerifierAction: ActionType {
	case readHoldersCredentials(completion: CompletionResult<VerifierViewCredentials>)
	case showCredentialsAsJson((JsonCredentialsResult) -> Void)
}

enum HolderAction: ActionType {
	case scanHolderCredentials(completion: CompletionResult<HolderViewCredentials>)
	case saveChanges(filesToDelete: [File], filesToUpdateSettings: [File], completion: CompletionResult<SimpleResponse>)
}
