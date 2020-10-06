//
//  TangemIdVerifier.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

final class TangemIdVerifier: ActionExecutioner {
	var executionerInfo: RoleInfo {
		VerifierRoleInfo()
	}
	
	func execute(action: VerifierAction) {
		switch action {
		case .readHoldersCredentials(let completion):
			completion(.success(()))
		}
	}
}
