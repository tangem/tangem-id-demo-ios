//
//  Module.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

enum Module {
	case issuer(roleInfo: RoleInfo, manager: TangemIssuerManager)
	case issuerCreateCredentials(manager: TangemIssuerManager)
}
