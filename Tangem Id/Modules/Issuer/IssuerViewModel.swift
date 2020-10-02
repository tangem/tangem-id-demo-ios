//
//  IssuerViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine

class IssuerViewModel: ObservableObject, Equatable {
	static func == (lhs: IssuerViewModel, rhs: IssuerViewModel) -> Bool {
		lhs.isCreatingCredentials == rhs.isCreatingCredentials
	}
	
	private let moduleAssembly: ModuleAssemblyType
	private let issuerManager: TangemIssuerManager
	
	@Published var isCreatingCredentials: Bool? = false
	
	private(set) var createCredentialsLink: AnyView = AnyView(EmptyView())
	private(set) var issuerInfo: IssuerRoleInfoType
	
	var disposable = Set<AnyCancellable>()
	
	init(moduleAssembly: ModuleAssemblyType, issuerInfo: IssuerRoleInfoType, issuerManager: TangemIssuerManager) {
		self.moduleAssembly = moduleAssembly
		self.issuerInfo = issuerInfo
		self.issuerManager = issuerManager
	}
	
	func createNewCredentials() {
		issuerManager.execute(action: .getHolderAddress { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success:
				self.createCredentialsLink = try! self.moduleAssembly.assembledView(for: .issuerCreateCredentials(manager: self.issuerManager))
				self.isCreatingCredentials = true
			case .failure(let error):
				print(error)
			}
		})
	}
	
}
