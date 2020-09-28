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
	
	private let moduleAssembly: ModuleAssembly
	
	var issuerLink: some View {
		try? moduleAssembly.assembledView(for: .issuer)
	}
	
	var veridierLink: some View {
		IssuerView()
	}
	
	var holderLink: some View {
		IssuerView()
	}
	
	init(moduleAssembly: ModuleAssembly) {
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
}
