//
//  IssuerAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject

struct IssuerAssembly: Assembly {
	func assemble(container: Container) {
		container.register(IssuerView.self) { r in
			guard let viewModel = r.resolve(IssuerViewModel.self) else {
				fatalError()
			}
			let view = IssuerView(viewModel: viewModel)
			return view
		}
		container.register(IssuerViewModel.self) { r in
			let moduleAssembly = self.moduleAssembly(r)
			return IssuerViewModel(moduleAssembly: moduleAssembly)
		}
		
		container.register(IssuerCreateCredentialsView.self) { r in
			guard let viewModel = r.resolve(IssuerCreateCredentialsViewModel.self) else {
				fatalError()
			}
			return IssuerCreateCredentialsView(viewModel: viewModel)
		}
		container.register(IssuerCreateCredentialsViewModel.self) { r in
			let moduleAssembly = self.moduleAssembly(r)
			return IssuerCreateCredentialsViewModel(moduleAssembly: moduleAssembly)
		}
	}
}
