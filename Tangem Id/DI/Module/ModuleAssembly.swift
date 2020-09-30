//
//  ModuleAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Swinject

class ModuleAssembly {
	private let resolver: Resolver
	
	init(resolver: Resolver) {
		self.resolver = resolver
	}
	
	private func resolveView<T>(for type: T.Type) throws -> T {
		guard let view = resolver.resolve(type) else {
			throw ModuleAssemblyError.dependencyResolvingError
		}
		return view
	}
}

extension ModuleAssembly {
	func assembledView(for module: Module) throws -> some View {
		switch module {
		case .issuer:
			return try resolveView(for: IssuerView.self)
		}
	}
}
