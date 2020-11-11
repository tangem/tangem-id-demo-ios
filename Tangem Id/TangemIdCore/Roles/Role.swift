//
//  Role.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

public enum Role {
	case issuer, verifier, holder
	
	public var validCardMask: ProductMask {
		switch self {
		case .issuer: return .idIssuer
		case .verifier, .holder: return .idCard
		}
	}
}
