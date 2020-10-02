//
//  IssuerViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine

private protocol TypeErasing {
    var view: Any { get }
	func isEqual(to view: TypeErasing) -> Bool
}

private struct TypeEraser<V: View & Equatable>: TypeErasing, Equatable {
    let orinal: V
    var view: Any {
        return self.orinal
    }
	
	func isEqual(to view: TypeErasing) -> Bool {
		guard let eraser = view as? TypeEraser else { return false }
		return orinal == eraser.orinal
	}
}

public struct AnyEquatableView : View, Equatable {
	public static func == (lhs: AnyEquatableView, rhs: AnyEquatableView) -> Bool {
		return lhs.eraser.isEqual(to: rhs.eraser)
	}
	
    public var body: Never {
        get {
            fatalError("Unsupported - don't call this")
        }
    }

    private var eraser: TypeErasing
    public init<V>(_ view: V) where V : View & Equatable {
        eraser = TypeEraser(orinal: view)
    }

    fileprivate var wrappedView: Any { // << they might have here something specific
		eraser.view
    }

    public typealias Body = Never
	
	public static var emptyView: AnyEquatableView {
		AnyEquatableView(EmptyEquatableView())
	}
}

public struct EmptyEquatableView: View, Equatable {
	public static func == (lhs: EmptyEquatableView, rhs: EmptyEquatableView) -> Bool {
		 return true
	}
	public var body: some View {
		EmptyView()
	}
}

class IssuerViewModel: ObservableObject, Equatable {
	static func == (lhs: IssuerViewModel, rhs: IssuerViewModel) -> Bool {
		lhs.isCreatingCredentials == rhs.isCreatingCredentials
	}
	
	private let moduleAssembly: ModuleAssemblyType
	
	@Published var isCreatingCredentials: Bool? = false
	
	private(set) var createCredentialsLink: AnyView = AnyView(EmptyView())
	
	var disposable = Set<AnyCancellable>()
	
	init(moduleAssembly: ModuleAssemblyType) {
		self.moduleAssembly = moduleAssembly
	}
	
	func createNewCredentials() {
		createCredentialsLink = try! moduleAssembly.assembledView(for: .issuerCreateCredentials)
		isCreatingCredentials = true
	}
	
}
