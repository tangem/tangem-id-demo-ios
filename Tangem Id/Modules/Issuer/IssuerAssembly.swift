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
		container.register(IssuerView.self) { (r, roleInfo: RoleInfo, manager: TangemIssuerManager) in
			guard let viewModel = r.resolve(IssuerViewModel.self, arguments: roleInfo, manager) else {
				fatalError()
			}
			let view = IssuerView(viewModel: viewModel)
			return view
		}
		container.register(IssuerViewModel.self) { (r, roleInfo: RoleInfo, manager: TangemIssuerManager) in
			let moduleAssembly = self.moduleAssembly(r)
			guard let issuerRoleInfo = roleInfo as? IssuerRoleInfoType else {
				fatalError("Wrong role info was created for Issuer role")
			}
			return IssuerViewModel(moduleAssembly: moduleAssembly, issuerInfo: issuerRoleInfo, issuerManager: manager)
		}
		
		container.register(IssuerCreateCredentialsView.self) { (r, manager: TangemIssuerManager) in
			guard let viewModel = r.resolve(IssuerCreateCredentialsViewModel.self, argument: manager) else {
				fatalError()
			}
			return IssuerCreateCredentialsView(viewModel: viewModel)
		}
		container.register(IssuerCreateCredentialsViewModel.self) { (r, manager: TangemIssuerManager) in
			let moduleAssembly = self.moduleAssembly(r)
			return IssuerCreateCredentialsViewModel(moduleAssembly: moduleAssembly, issuerManager: manager)
		}
		
		// used for creating preview
		container.register(IssuerCreateCredentialsView.self) { r in
			let tangemFactory = self.tangemIdManagerFactory(r)
			let issuer = tangemFactory.createIssuerManager()
			return r.resolve(IssuerCreateCredentialsView.self, argument: issuer)!
		}
	}
}
