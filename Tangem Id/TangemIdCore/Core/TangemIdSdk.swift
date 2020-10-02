//
//  TangemIdSdk.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import Combine
//
//protocol ActionExecutioner {
//	var executionerInfo: RoleInfo { get }
//	func execute(action: RoleAction, completion: @escaping ActionResult)
//}

protocol ActionExecutioner {
	associatedtype Action: ActionType
	var executionerInfo: RoleInfo { get }
	func execute(action: Action, completion: @escaping ActionResult)
}

typealias ActionResult = (Result<Void, Error>) -> Void

final class TangemIdSdk<T: ActionExecutioner> {
	
	private(set) var executioner: T
	
	var executionerInfo: RoleInfo {
		executioner.executionerInfo
	}
	
	init(executioner: T) {
		self.executioner = executioner
	}
	
	func execute(action: T.Action, completion: @escaping ActionResult = { _ in }) {
		executioner.execute(action: action, completion: completion)
	}
	
}

//final class TangemIdSdk {
//
//	private(set) var tangemSdk: TangemSdk
//	private(set) var issuer: TangemIdIssuer
//
//	private var executioner: ActionExecutioner?
//
//	private var authorizedRole: Role?
//
//	var authorizedRoleInfo: RoleInfo? {
//		executioner?.executionerInfo
//	}
//
//	init() {
//		tangemSdk = TangemSdk()
//		issuer = TangemIdIssuer(tangemSdk: tangemSdk)
//	}
//
//	func authorize(as role: Role, completion: @escaping ActionResult) {
//		authorizedRole = nil
//		executioner = nil
//		switch role {
//		case .verifier:
//			authorizedRole = .verifier
//			completion(.success(()))
//		case .issuer:
//			let issuer = TangemIdIssuer(tangemSdk: tangemSdk)
//			executioner = issuer
//			execute(action: .asIssuer(action: .authorizeAsIssuer)) { [weak self] (result) in
//				switch result {
//				case .success:
//					self?.authorizedRole = .issuer
//				case .failure(let error):
//					print("Failed to authorized as Issuer due to an:", error)
//				}
//				completion(result)
//			}
//		case .holder:
//			authorizedRole = .holder
//		}
//	}
//
//	func execute(action: RoleAction, completion: @escaping ActionResult = { (_) in }) {
//		guard let exec = executioner else {
//			completion(.failure(TangemIdError.youNotAuthorized))
//			return
//		}
//		if action.shouldCheckRole, authorizedRole != action.role {
//			completion(.failure(TangemIdError.wrongAuthorization))
//		}
//		exec.execute(action: action, completion: completion)
//	}
//
//}
