//
//  TangemIdIssuer.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk
import BlockchainSdk
import Combine

final class TangemIdIssuer: ActionExecutioner {
	
	private let tangemSdk: TangemSdk
	private let walletFactory = WalletManagerFactory()
	private let ethereumBlockchain = Blockchain.ethereum(testnet: false)
	
	private var issuerCardId: String?
	private var issuerWallet: WalletManager?
	private var holderCardId: String?
	private var holderPublicKey: String?
	
	private var walletAddress: String?
	
	var executionerInfo: RoleInfo {
		guard
			let wallet = walletAddress
		else { return IssuerRoleInfo.emptyInfo }
		return IssuerRoleInfo(didWalletAddress: "did:ethr:" + wallet, qrImage: #imageLiteral(resourceName: "qr"), title: "Issuer", description: "My soft issuer", image: nil)
	}
	
	init(tangemSdk: TangemSdk) {
		self.tangemSdk = tangemSdk
	}
	
	func execute(action: IssuerAction, completion: @escaping ActionResult) {
		switch action {
		case .authorizeAsIssuer(let handler):
			authorizeIssuer(emptyResponseHandler: handler, completion: completion)
		case .getHolderAddress(let handler):
			scanHolderCard(emptyResponseHandler: handler, completion: completion)
		default:
			break
		}
	}
	
	private func authorizeIssuer(emptyResponseHandler: @escaping EmptyResponse, completion: @escaping ActionResult) {
		tangemSdk.scanCard(initialMessage: Message(header: IdLocalization.Common.scanIssuerCard, body: nil)) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success(let cardInfo):
				guard
					cardInfo.cardData?.productMask?.contains(.idIssuer) ?? false,
					self.isValidIssuerCard(cardInfo)
				else {
						completion(.failure(TangemSdkError.underlying(error: TangemIdError.notValidIssuerCard)))
						return
				}
				let wallet = self.walletFactory.makeWalletManager(from: cardInfo)
				self.walletAddress = wallet?.wallet.address
				self.issuerWallet = wallet
				emptyResponseHandler(.success(()))
				completion(.success(()))
			case .failure(let error):
				emptyResponseHandler(.failure(.cardSdkError(sdkError: error.localizedDescription)))
				completion(.failure(error))
			}
		}
	}
	
	private func scanHolderCard(emptyResponseHandler: @escaping EmptyResponse, completion: @escaping ActionResult) {
		tangemSdk.scanCard(initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil)) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success(let card):
				guard
					self.isValidHolderCard(card),
					let walletPublicKey = card.walletPublicKey
				else {
					completion(.failure(TangemIdError.notValidHolderCard))
					emptyResponseHandler(.failure(.notValidHolderCard))
					return
				}
				self.holderCardId = card.cardId
				self.holderPublicKey = self.ethereumBlockchain.makeAddress(from: walletPublicKey)
				emptyResponseHandler(.success(()))
			case .failure(let error):
				completion(.failure(error))
				emptyResponseHandler(.failure(TangemIdError.cardSdkError(sdkError: error.localizedDescription)))
			}
		}
	}
	
	
	private func isValidIssuerCard(_ card: Card) -> Bool {
		guard
			let curve = card.curve,
			card.walletPublicKey != nil
			else { return false }
		return curve == .secp256k1
	}
	
	private func isValidHolderCard(_ card: Card) -> Bool {
		guard
			card.cardData?.productMask?.contains(.idCard) ?? false
		else { return false }
		return true
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
