//
//  IssuerViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

class IssuerViewModel: ObservableObject {
	
	private let moduleAssembly: ModuleAssemblyType
	
	@Published var isCreatingCredentials: Bool = false
	
	var createCredentialsLink: AnyView {
		guard isCreatingCredentials else { return AnyView(EmptyView()) }
		return AnyView(try? moduleAssembly.assembledView(for: .issuerCreateCredentials))
	}
	
	init(moduleAssembly: ModuleAssemblyType) {
		self.moduleAssembly = moduleAssembly
	}
	
	func createNewCredentials() {
		isCreatingCredentials = true
	}
	
}
