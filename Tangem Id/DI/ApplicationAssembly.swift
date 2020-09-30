//
//  ApplicationAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Swinject

final class ApplicationAssembly {
	
	static let assembler = Assembler(
		[
			ServiceAssembly(),
			
			RoleSelectorAssembly(),
			IssuerAssembly()
		]
	)
	
}
