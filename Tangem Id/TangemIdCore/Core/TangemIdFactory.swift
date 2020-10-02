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
	func makeManager<T: ActionExecutioner>(for role: Role) -> TangemIdSdk<T>
}

struct TangemIdFactory: TangemIdFactoryType {
	
	let tangemSdk: TangemSdk
	
	func makeManager<T: ActionExecutioner>(for role: Role) -> TangemIdSdk<T> {
		switch role {
		case .issuer:
			return TangemIdSdk(executioner: TangemIdIssuer(tangemSdk: tangemSdk) as! T)
		default:
			return TangemIdSdk(executioner: TangemIdIssuer(tangemSdk: tangemSdk) as! T)
		}
	}
	
}
