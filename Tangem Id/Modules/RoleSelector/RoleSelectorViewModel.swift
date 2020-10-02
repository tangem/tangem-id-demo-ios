//
//  OnboardingViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Combine
import SwiftUI

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
	
	private var disposable = Set<AnyCancellable>()
	
	private let moduleAssembly: ModuleAssemblyType
	
	private(set) var issuerLink: AnyView = AnyView(EmptyView())
	
	var veridierLink: AnyView {
		AnyView(EmptyView())
	}
	
	var holderLink: AnyView {
		AnyView(EmptyView())
	}
	
	init(moduleAssembly: ModuleAssemblyType) {
		self.moduleAssembly = moduleAssembly
		
		// TODO: Try to rework single link for every view state through subscription
//		let subs = $state
//			.sink(receiveValue: {
//				print("Current state of Role selector view", $0)
//			})
//		disposable.insert(subs)
	}
	
	
}

extension RoleSelectorViewModel {
	func issuerButtonAction() {
		issuerLink = try! moduleAssembly.assembledView(for: .issuer)
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
