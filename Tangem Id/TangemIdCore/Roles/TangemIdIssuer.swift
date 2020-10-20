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
import SwiftCBOR

typealias TangemIssuerManager = TangemIdSdk<TangemIdIssuer>

final class TangemIdIssuer: ActionExecutioner {
	
	private let tangemSdk: TangemSdk
	private let walletFactory = WalletManagerFactory()
	private let ethereumBlockchain = Blockchain.ethereum(testnet: false)
	private let credentialCreatorFactory: CredentialCreatorFactoryType
	
	private var credsController: CredentialsControllerType?
	private var credentialCreator: CredentialCreator?
	
	// MARK: Issuer info
	private var issuerCardId: String?
	private var issuerWallet: WalletManager?
	private var issuerWalletAddress: String?
	
	// MARK: Holder info
	private var holderCardId: String?
	private var holderEthAddress: String?
	
	private var processingQueue: DispatchQueue = .init(label: "IssuerDispatchQueue", qos: .utility)
	private var signWorkItem: DispatchWorkItem?
	
	private var disposables = Set<AnyCancellable>()
	
	var executionerInfo: RoleInfo {
		guard
			let wallet = issuerWalletAddress
		else { return IssuerRoleInfo.emptyInfo }
		return IssuerRoleInfo(didWalletAddress: IdConstants.didPrefix + wallet, qrImage: #imageLiteral(resourceName: "qr"), title: "Issuer", description: "My soft issuer", image: nil)
	}
	
	init(tangemSdk: TangemSdk, credentialCreatorFactory: CredentialCreatorFactoryType) {
		self.tangemSdk = tangemSdk
		self.credentialCreatorFactory = credentialCreatorFactory
	}
	
	func execute(action: IssuerAction) {
		switch action {
		case .authorizeAsIssuer(let handler):
			authorizeIssuer(completion: handler)
		case .getHolderAddress(let handler):
			scanHolderCard(completion: handler)
		case let .signCredentials(input, completionHandler):
			sign(input: input, completion: completionHandler)
		case .saveCredentialsToCard(let handler):
			writeCredsToCard(completion: handler)
		case .showCredentialsAsJson(let handler):
			displayCredsAsJson(completion: handler)
		}
	}
	
	private func authorizeIssuer(completion: @escaping EmptyResponse) {
		tangemSdk.scanCard(initialMessage: Message(header: IdLocalization.Common.scanIssuerCard, body: nil)) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success(let cardInfo):
				guard
					cardInfo.cardData?.productMask?.contains(.idIssuer) ?? false,
					self.isValidIssuerCard(cardInfo),
					let cardId = cardInfo.cardId
				else {
					completion(.failure(.notValidIssuerCard))
					return
				}
				let wallet = self.walletFactory.makeWalletManager(from: cardInfo)
				self.issuerWalletAddress = wallet?.wallet.address
				self.issuerWallet = wallet
				self.issuerCardId = cardId
				self.credsController = DemoCredentialsController(tangemSdk: self.tangemSdk,
																 credentialCreator: self.credentialCreatorFactory.makeCreator(.demo),
																 issuerCardId: cardId,
																 issuerWalletAddress: wallet!.wallet.address,
																 proofCreator: Secp256k1ProofCreator())
				completion(.success(()))
			case .failure(let error):
				completion(.failure(.cardSdkError(sdkError: error.localizedDescription)))
			}
		}
	}
	
	private func scanHolderCard(completion: @escaping EmptyResponse) {
		tangemSdk.scanCard(initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil)) { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success(let card):
				guard
					self.isValidHolderCard(card),
					let walletPublicKey = card.walletPublicKey
				else {
					completion(.failure(.notValidHolderCard))
					return
				}
				self.holderCardId = card.cardId
				self.holderEthAddress = self.ethereumBlockchain.makeAddress(from: walletPublicKey)
				completion(.success(()))
			case .failure(let error):
				completion(.failure(TangemIdError.cardSdkError(sdkError: error.localizedDescription)))
			}
		}
	}
	
	private func sign(input: CredentialInput, completion: @escaping EmptyResponse) {
		guard
			let holderEthAddress = holderEthAddress
			else {
			completion(.failure(.notValidIssuerCard))
			return
		}
		signWorkItem = DispatchWorkItem { [weak self] in
			self?.credsController?.signCredentials(for: input, subjectEthAddress: holderEthAddress, completion: completion)
		}
		processingQueue.async(execute: signWorkItem!)
	}
	
	private func writeCredsToCard(completion: @escaping EmptyResponse) {
		credsController?.writeCredentialsToCard(completion: completion)
	}
	
	private func displayCredsAsJson(completion: @escaping (JsonCredentialsResult) -> Void) {
		credsController?.credentialsAsJson(completion: completion)
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
