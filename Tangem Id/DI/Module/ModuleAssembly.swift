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
		case .issuer:
			return try resolveView(for: IssuerView.self)
		case .issuerCreateCredentials:
//			return AnyView(resolver.resolve(IssuerCreateCredentialsView.self))
			return try resolveView(for: IssuerCreateCredentialsView.self)
		}
	}
}
