//
//  ModuleAssembly.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Swinject

protocol ModuleAssemblyType {
	func assembledView(for module: Module) throws -> AnyView
}

class ModuleAssembly {
	private let resolver: Resolver
	
	init(resolver: Resolver) {
		self.resolver = resolver
	}
	
	private func resolveView<T: View>(for type: T.Type) throws -> AnyView {
		guard let view = resolver.resolve(type) else {
			throw ModuleAssemblyError.dependencyResolvingError
		}
		return AnyView(view)
	}
	
}

extension ModuleAssembly: ModuleAssemblyType {
	func assembledView(for module: Module) throws -> AnyView {
		switch module {
		case .issuer(let info):
			guard let view = resolver.resolve(IssuerView.self, argument: info) else {
				throw ModuleAssemblyError.dependencyResolvingError
			}
			return AnyView(view)
		case .issuerCreateCredentials:
			return try resolveView(for: IssuerCreateCredentialsView.self)
		}
	}
}
