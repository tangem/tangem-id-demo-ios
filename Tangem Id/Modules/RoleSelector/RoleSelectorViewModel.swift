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
	
	var issuerLink: some View {
		IssuerView()
	}
	
	var veridierLink: some View {
		IssuerView()
	}
	
	var holderLink: some View {
		IssuerView()
	}
	
	init() {

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
