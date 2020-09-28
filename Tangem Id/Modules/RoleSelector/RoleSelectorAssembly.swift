//
//  RoleSelectorAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject
import SwiftUI

struct RoleSelectorAssembly: Assembly {
	func assemble(container: Container) {
		container.register(RoleSelectorView.self) { r in
			guard let viewModel = r.resolve(RoleSelectorViewModel.self) else {
				fatalError("Failed to resolve Role selector view model")
			}
			return RoleSelectorView(viewModel: viewModel)
		}
		container.register(RoleSelectorViewModel.self) { r in
			return RoleSelectorViewModel()
		}
	}
}
