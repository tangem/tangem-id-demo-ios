//
//  ServiceAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject

struct ServiceAssembly: Assembly {
	func assemble(container: Container) {
		container.register(ModuleAssemblyType.self, factory: { r in ModuleAssembly(resolver: r) } ).inObjectScope(.container)
	}
}
