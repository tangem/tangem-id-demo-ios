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
		let sdk = TangemIdSdk(executioner: TangemIdIssuer(tangemSdk: TangemSdk()))
		sdk.execute(action: .authorizeAsIssuer({ [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success:
				let info = sdk.executionerInfo
				self.issuerLink = try! self.moduleAssembly.assembledView(for: .issuer(roleInfo: info))
				self.state = .issuer
			case .failure(let error):
				self.error = error
			}
		}))
//		tangemId.authorize(as: .issuer) { [weak self] (result) in
//			guard let self = self else { return }
//			switch result {
//			case .success:
//				let info = self.tangemId.authorizedRoleInfo
////				self.issuerLink = try! self.moduleAssembly.assembledView(for: .issuer(roleInfo: info))
//				self.state = .issuer
//			case .failure(let error):
//				self.error = error
//			}
//		}
//		tangemId.issuer.readIssuerCard { [weak self] (result) in
//			guard let self = self else { return }
//			switch result {
//			case .success(let issuerInfo):
//				self.issuerLink = try! self.moduleAssembly.assembledView(for: .issuer(issuerInfo: issuerInfo))
//				self.state = .issuer
//			case .failure(let error):
//				if
//					case let TangemSdkError.underlying(error) = error,
//					let idError = error as? TangemIdError
//				{
//					self.state = .error(error: .idCoreError(error: idError))
//				}
//			}
//		}
		
	}
	
	func verifierButtonAction() {
//		tangemId.authorize(as: .verifier) { (_) in
//
//		}
		let sdk = TangemIdSdk(executioner: TangemIdVerifier())
		sdk.execute(action: .readHoldersCredentials(completion: { [weak self] (result) in
			guard let self = self else { return }
			self.state = .verifier
		}))
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
