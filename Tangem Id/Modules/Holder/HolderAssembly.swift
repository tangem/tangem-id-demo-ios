//
//  HolderAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject

struct HolderAssembly: Assembly {
	func assemble(container: Container) {
		
		container.register(HolderView.self) { (r, manager: TangemHolderManager, creds: HolderViewCredentials) in
			guard let viewModel = r.resolve(HolderViewModel.self, arguments: manager, creds) else {
				fatalError("Failed to resolve Holder view model")
			}
			return HolderView(viewModel: viewModel)
		}
		container.register(HolderViewModel.self) { (r, manager: TangemHolderManager, creds: HolderViewCredentials) in
			return HolderViewModel(holderManager: manager, holderCredentials: creds)
		}
		
		container.register(HolderView.self) { r in
			let factory = self.tangemIdManagerFactory(r)
			let manager = factory.createHolderManager()
			return r.resolve(HolderView.self, arguments: manager, HolderViewCredentials.demo)!
		}
	}
}
