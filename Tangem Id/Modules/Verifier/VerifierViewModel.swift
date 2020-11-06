//
//  VerifierViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

struct VerifierCredentials<T: DemoCredential> {
	let credentials: T
	let issuer: IssuerVerificationInfo
	let status: VerificationStatus
}

class VerifierViewModel: ObservableObject, SnackMessageDisplayable {
	
	@Published var snackMessage: SnackData = .emptySnack
	@Published var isShowingSnack: Bool = false
	@Published var jsonRepresentation: String = ""
	
	private let verifier: TangemVerifierManager
	let credentials: VerifierViewCredentials
	
	init(verifier: TangemVerifierManager, credentials: VerifierViewCredentials) {
		self.verifier = verifier
		self.credentials = credentials
	}
	
	func loadJsonRepresentation() {
		verifier.execute(action: .showCredentialsAsJson({ (result) in
			switch result {
			case .success(let json):
				self.jsonRepresentation = json
			case .failure(let error):
				self.showErrorSnack(message: error.localizedDescription)
			}
		}))
	}
	
}
