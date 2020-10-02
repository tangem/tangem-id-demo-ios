//
//  RoleAction.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

protocol ActionType {}

typealias EmptyResponse = (Result<Void, TangemIdError>) -> Void


enum IssuerAction: ActionType {
	case authorizeAsIssuer(EmptyResponse)
	case getHolderAddress(EmptyResponse)
	case createAndSignCredentials
	case saveCredentialsToCard
}

enum VerifierAction: ActionType {
	case readHoldersCredentials(completion: EmptyResponse)
}

//enum RoleAction {
//	case asIssuer(action: IssuerAction)
//	case asVerifier(action: VerifierAction)
//
//	var role: Role {
//		switch self {
//		case .asIssuer: return .issuer
//		case .asVerifier: return .verifier
//		}
//	}
//
//	var shouldCheckRole: Bool {
//		switch self {
//		case .asIssuer(let action):
//			return action.shouldCheckRole
//		default:
//			return false
//		}
//	}
//
//	enum IssuerAction {
//		case authorizeAsIssuer
//		case getHolderAddress
//		case createAndSignCredentials
//		case saveCredentialsToCard
//
//		var shouldCheckRole: Bool {
//			switch self {
//			case .authorizeAsIssuer: return false
//			default: return true
//			}
//		}
//	}
//
//	enum VerifierAction {
//		case readHoldersCredentials(completion: CompletionResult<Card>)
//	}
//}
