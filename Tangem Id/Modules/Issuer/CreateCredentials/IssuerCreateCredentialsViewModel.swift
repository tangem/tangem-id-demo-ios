//
//  IssuerCreateCredentialsViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

class IssuerCreateCredentialsViewModel: ObservableObject {
	
	private let moduleAssembly: ModuleAssemblyType
	
	init(moduleAssembly: ModuleAssemblyType) {
		self.moduleAssembly = moduleAssembly
	}
	
}
