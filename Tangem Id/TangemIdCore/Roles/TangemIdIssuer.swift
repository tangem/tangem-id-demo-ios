//
//  TangemIdIssuer.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

final class TangemIdIssuer: ActionExecutioner {
	
	private let tangemSdk: TangemSdk
	private var issuerCardId: String?
	private var walletAddress: String?
	
	var executionerInfo: RoleInfo {
		guard
			let wallet = walletAddress
		else { return IssuerRoleInfo.emptyInfo }
		return IssuerRoleInfo(didWalletAddress: wallet, qrImage: #imageLiteral(resourceName: "qr"), title: "Issuer", description: "My soft issuer", image: nil)
	}
	
	init(tangemSdk: TangemSdk) {
		self.tangemSdk = tangemSdk
	}
	
	func execute(action: IssuerAction, completion: @escaping ActionResult) {
		switch action {
		case .authorizeAsIssuer(let handler):
			authorizeIssuer(emptyResponseHandler: handler, completion: completion)
		default:
			break
		}
	}
	
	private func authorizeIssuer(emptyResponseHandler: @escaping EmptyResponse, completion: @escaping ActionResult) {
		tangemSdk.scanCard(initialMessage: Message(header: IdLocalization.Common.scanIssuerCard, body: nil)) { (result) in
			switch result {
			case .success(let cardInfo):
				guard
					cardInfo.cardData?.productMask?.contains(.idIssuer) ?? false,
					self.isValidCard(cardInfo)
					else {
						completion(.failure(TangemSdkError.underlying(error: TangemIdError.notValidIssuerCard)))
						return
				}
				self.walletAddress = "121d3mdmkf43v3ko4f3"
				emptyResponseHandler(.success(()))
				completion(.success(()))
			case .failure(let error):
				emptyResponseHandler(.failure(.cardSdkError(sdkError: error.localizedDescription)))
				completion(.failure(error))
			}
		}
	}
	
	
	private func isValidCard(_ card: Card) -> Bool {
		guard
			let curve = card.curve,
			card.walletPublicKey != nil
			else { return false }
		return curve == .secp256k1
	}
}

final class TangemIdVerifier: ActionExecutioner {
	var executionerInfo: RoleInfo {
		VerifierRoleInfo()
	}
	
	func execute(action: VerifierAction, completion: @escaping ActionResult) {
		switch action {
		case .readHoldersCredentials(let completion):
			completion(.success(()))
		}
	}
}

//final class TangemIdIssuer: ActionExecutioner {
//
//	private let tangemSdk: TangemSdk
//
//	var executionerInfo: RoleInfo {
//		guard
//			let wallet = walletAddress
//		else { return IssuerRoleInfo.emptyInfo }
//		return IssuerRoleInfo(didWalletAddress: wallet, qrImage: #imageLiteral(resourceName: "qr"), title: "Issuer", description: "My soft issuer", image: nil)
//	}
//
//	private var issuerCardId: String?
//	private var walletAddress: String?
//
//	init(tangemSdk: TangemSdk) {
//		self.tangemSdk = tangemSdk
//	}
//
//	private func isValidCard(_ card: Card) -> Bool {
//		guard
//			let curve = card.curve,
//			card.walletPublicKey != nil
//			else { return false }
//		return curve == .secp256k1
//	}
//
//
//
//	func execute(action: RoleAction, completion: @escaping ActionResult) {
////		guard case let .asIssuer(issuerAction) = action else {
////			completion(.failure(TangemIdError.wrongAuthorization))
////			return
////		}
////		switch issuerAction {
////		case .authorizeAsIssuer:
////			readIssuerCard { (<#Result<IssuerInfo, TangemSdkError>#>) in
////				<#code#>
////			}
////		default:
////			<#code#>
////		}
//	}
//
//	func readIssuerCard(completion: @escaping CompletionResult<IssuerInfo>) {
//		tangemSdk.scanCard(initialMessage: Message(header: IdLocalization.Common.scanIssuerCard, body: nil)) { (result) in
//			switch result {
//			case .success(let cardInfo):
//				guard
//					cardInfo.cardData?.productMask?.contains(.idIssuer) ?? false,
//					self.isValidCard(cardInfo)
//					else {
//						completion(.failure(.underlying(error: TangemIdError.notValidIssuerCard)))
//						return
//				}
//				completion(.success(IssuerInfo(walletAddress: "did:ethr", name: "Some issuer")))
//			case .failure(let error):
//				completion(.failure(error))
//			}
//		}
//	}
//
//}
