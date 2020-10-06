//
//  OnboardingViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Combine
import SwiftUI
import TangemSdk

final class RoleSelectorViewModel: ObservableObject, Equatable {
	
	static func == (lhs: RoleSelectorViewModel, rhs: RoleSelectorViewModel) -> Bool {
		lhs.state == rhs.state
	}
	
	enum ViewState: Hashable {
		case `default`, issuer, verifier, holder
	}
	
	@Published var state: ViewState? = .default  {
		willSet {
			if newValue == nil {
				state = .default
			}
		}
	}
	@Published var error: Error?
	
	private var disposable = Set<AnyCancellable>()
	
	private let moduleAssembly: ModuleAssemblyType
	private let tangemIdFactory: TangemIdFactoryType
	
	private(set) var issuerLink: AnyView = AnyView(EmptyView())
	
	var veridierLink: AnyView {
		AnyView(EmptyView())
	}
	
	var holderLink: AnyView {
		AnyView(EmptyView())
	}
	
	init(moduleAssembly: ModuleAssemblyType, tangemIdFactory: TangemIdFactoryType) {
		self.moduleAssembly = moduleAssembly
		self.tangemIdFactory = tangemIdFactory
	}
	
}

extension RoleSelectorViewModel {
	func issuerButtonAction() {
		let manager = tangemIdFactory.createIssuerManager()
		manager.execute(action: .authorizeAsIssuer({ [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success:
				let info = manager.executionerInfo
				self.issuerLink = try! self.moduleAssembly.assembledView(for: .issuer(roleInfo: info, manager: manager))
				self.state = .issuer
			case .failure(let error):
				self.error = error
			}
		}))
	}
	
	func verifierButtonAction() {
		state = .verifier
	}
	
	func holderButtonAction() {
		state = .holder
	}
	
	func openShop() {
		let app = UIApplication.shared
		guard
			let url = URL(string: Constants.shopUrl),
			app.canOpenURL(url)
		else { return }
		app.open(url, options: [:], completionHandler: nil)
	}
}
