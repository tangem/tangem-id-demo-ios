//
//  VerifierAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject

struct VerifierAssembly: Assembly {
	func assemble(container: Container) {
		container.register(VerifierView.self) { (r, verifier: TangemVerifierManager, credentials: VerifierViewCredentials) in
			guard let viewModel = r.resolve(VerifierViewModel.self, arguments: verifier, credentials) else {
				fatalError("Failed to resolve Verifier view model")
			}
			return VerifierView(viewModel: viewModel)
		}
		container.register(VerifierViewModel.self) { (r, verifier: TangemVerifierManager, credentials: VerifierViewCredentials) in
			VerifierViewModel(verifier: verifier, credentials: credentials)
		}
		
		container.register(VerifierView.self) { r in
			let tangemFactory = self.tangemIdManagerFactory(r)
			let verifier = tangemFactory.createVerifierManager()
			return r.resolve(VerifierView.self, arguments: verifier, VerifierViewCredentials.demo)!
		}
	}
}
