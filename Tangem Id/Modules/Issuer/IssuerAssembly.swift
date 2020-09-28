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
			IssuerView()
		}
	}
}
