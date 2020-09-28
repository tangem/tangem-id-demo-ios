//
//  OnboardingViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Combine
import SwiftUI

final class RoleSelectorViewModel: ObservableObject {
	
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
	
	private let moduleAssembly: ModuleAssemblyType
	
	var issuerLink: AnyView {
		guard state == .issuer else { return AnyView(EmptyView()) }
		return AnyView(try? moduleAssembly.assembledView(for: .issuer))
	}
	
	var veridierLink: AnyView {
		AnyView(EmptyView())
	}
	
	var holderLink: AnyView {
		AnyView(EmptyView())
	}
	
	init(moduleAssembly: ModuleAssemblyType) {
		self.moduleAssembly = moduleAssembly
	}
	
	
}

extension RoleSelectorViewModel {
	func issuerButtonAction() {
		state = .issuer
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
