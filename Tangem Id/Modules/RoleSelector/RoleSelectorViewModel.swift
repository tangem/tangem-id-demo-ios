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

final class RoleSelectorViewModel: ObservableObject, Equatable, SnackMessageDisplayable {
	
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
	@Published var isIssuer: Bool = false
	@Published var isVerifier: Bool = false
	@Published var isHolder: Bool = false
	@Published var error: Error?
	@Published var snackMessage: SnackData = .emptySnack
	@Published var isShowingSnack: Bool = false
	
	private var disposable = Set<AnyCancellable>()
	
	private let moduleAssembly: ModuleAssemblyType
	private let tangemIdFactory: TangemIdFactoryType
	
	private(set) var issuerLink: AnyView = AnyView(EmptyView())
	private(set) var verifierLink: AnyView = AnyView(EmptyView())
	private(set) var holderLink: AnyView = AnyView(EmptyView())
	
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
				self.isIssuer = true
				self.state = .issuer
			case .failure(let error):
				self.showErrorSnack(error: error)
			}
		}))
	}
	
	func verifierButtonAction() {
		let manager = tangemIdFactory.createVerifierManager()
		manager.execute(action: .readHoldersCredentials(completion: { (result) in
			switch result {
			case .success(let creds):
				self.verifierLink = try! self.moduleAssembly.assembledView(for: .verifier(manager: manager, credentials: creds))
				self.isVerifier = true
				self.state = .verifier
			case .failure(let error):
				self.showErrorSnack(error: error)
			}
		}))
	}
	
	func holderButtonAction() {
		let manager = tangemIdFactory.createHolderManager()
		manager.execute(action: .scanHolderCredentials(completion: { (result) in
			switch result {
			case .success(let creds):
				self.holderLink = try! self.moduleAssembly.assembledView(for: .holder(manager: manager, credentials: creds))
				self.isHolder = true
				self.state = .holder
			case .failure(let error):
				self.showErrorSnack(error: error)
			}
		}))
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
