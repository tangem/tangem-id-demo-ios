//
//  ServiceAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject
import TangemSdk

struct ServiceAssembly: Assembly {
	func assemble(container: Container) {
		container.register(ModuleAssemblyType.self, factory: { r in ModuleAssembly(resolver: r) } ).inObjectScope(.container)
		
		container.register(TangemSdk.self) { _ in TangemSdk() }.inObjectScope(.container)
		container.register(TangemIdFactoryType.self) { r in
			guard let sdk = r.resolve(TangemSdk.self) else {
				fatalError("Failed to resolve Tangem SDK")
			}
			return TangemIdFactory(tangemSdk: sdk)
		}.inObjectScope(.container)
	}
}
