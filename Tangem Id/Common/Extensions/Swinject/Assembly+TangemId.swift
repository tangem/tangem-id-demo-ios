//
//  Assembly+TangemId.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject

extension Assembly {
	func tangemIdManagerFactory(_ r: Resolver) -> TangemIdFactoryType {
		guard let tangemSdk = r.resolve(TangemIdFactoryType.self) else {
			fatalError("Failed to instantiate Tangem Id Sdk")
		}
		return tangemSdk
	}
}
