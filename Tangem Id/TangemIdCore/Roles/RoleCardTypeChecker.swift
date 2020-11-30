//
//  RoleCardTypeChecker.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

@available (iOS 13.0, *)
extension ProductMask {
	var cardTypeCheckError: TangemIdError {
		switch self {
		case .idCard: return .notValidHolderCard
		case .idIssuer: return .notValidIssuerCard
		default: return .notValidCard
		}
	}
}

@available (iOS 13.0, *)
protocol RoleCardTypeChecker {
	func isValidCard(type: ProductMask, in session: CardSession, shouldStopSessionIfNotValid shouldStop: Bool) -> Bool
	func isValidCard(for role: Role, in session: CardSession, shouldStopSessionIfNotValid shouldStop: Bool) -> Bool
}

@available (iOS 13.0, *)
extension RoleCardTypeChecker {
	func isValidCard(type: ProductMask, in session: CardSession, shouldStopSessionIfNotValid shouldStop: Bool) -> Bool {
		guard session.environment.card?.cardData?.productMask?.contains(type) ?? false else {
			if shouldStop {
				session.stop(error: type.cardTypeCheckError)
			}
			return false
		}
		return true
	}
	
	func isValidCard(for role: Role, in session: CardSession, shouldStopSessionIfNotValid shouldStop: Bool) -> Bool {
		isValidCard(type: role.validCardMask, in: session, shouldStopSessionIfNotValid: shouldStop)
	}
}
