//
//  TangemIdHolder.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import BlockchainSdk
import TangemSdk_secp256k1

typealias TangemHolderManager = TangemIdSdk<TangemIdHolder>

final class TangemIdHolder: ActionExecutioner {
	
	private let tangemSdk: TangemSdk
	private let viewCredentialFactory: ViewCredentialFactory
	private let credentialCreator: CredentialCreator
	private let proofCreator: Secp256k1ProofCreatorType
	
	private let ethBlockchain: Blockchain = .ethereum(testnet: false)
	
	private var cardId: String?
	private var holderAddress: String?
	private var holderViewCredentials: HolderViewCredentials?
	private var holderCredentials: [VerifiableCredential]?
	
	var executionerInfo: RoleInfo {
		HolderRoleInfo()
	}
	
	public init(tangemSdk: TangemSdk, viewCredentialFactory: ViewCredentialFactory, credentialCreator: CredentialCreator, proofCreator: Secp256k1ProofCreatorType) {
		self.tangemSdk = tangemSdk
		self.viewCredentialFactory = viewCredentialFactory
		self.credentialCreator = credentialCreator
		self.proofCreator = proofCreator
	}
	
	func execute(action: HolderAction) {
		switch action {
		case .scanHolderCredentials(let completion):
			scanHolderCreds(completion: completion)
		case let .saveChanges(filesToDelete, filesToUpdateSettings, completion):
			updateFiles(filesToDelete: filesToDelete, filesToUpdateSettings: filesToUpdateSettings, completion: completion)
		case .requestCovidCreds(let completion):
			createCovidCreds(completion: completion)
		case .changePasscode(let completion):
			changePasscode(completion: completion)
		}
	}
	
	private func scanHolderCreds(completion: @escaping CompletionResult<HolderViewCredentials>) {
		let holderReadTask = ReadHolderCardTask(settings: ReadFilesTaskSettings(readPrivateFiles: true), role: .holder)
		tangemSdk.startSession(with: holderReadTask, initialMessage: IdMessages.scanHolderCard) { (result) in
			switch result {
			case .success(let response):
				self.createCreds(response: response, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func createCreds(response: ReadHolderCardTaskResponse, completion: @escaping CompletionResult<HolderViewCredentials>) {
		holderAddress = ethBlockchain.makeAddress(from: response.walletPublicKey)
		var cardId = response.cardId
		self.cardId = cardId
		if cardId.count == 16 {
			let startIndex = cardId.startIndex
			cardId.insert(" ", at: cardId.index(startIndex, offsetBy: 12))
			cardId.insert(" ", at: cardId.index(startIndex, offsetBy: 8))
			cardId.insert(" ", at: cardId.index(startIndex, offsetBy: 4))
		}
		let factoryResult = viewCredentialFactory.createHolderViewCreds(cardId: cardId, files: response.files)
		switch factoryResult {
		case .success(let tuplet):
			holderCredentials = tuplet.creds
			holderViewCredentials = tuplet.viewCreds
			completion(.success(tuplet.viewCreds))
		case .failure(let error):
			completion(.failure(.underlying(error: error)))
		}
	}
	
	private func updateFiles(filesToDelete: [File], filesToUpdateSettings: [File], completion: @escaping CompletionResult<SimpleResponse>) {
		let changeFilesTask = ChangeFilesTask(filesToDelete: filesToDelete, filesToUpdateSettings: filesToUpdateSettings)
		tangemSdk.startSession(with: changeFilesTask, initialMessage: IdMessages.scanHolderCard, completion: completion)
	}
	
	private func createCovidCreds(completion: @escaping CompletionResult<HolderCredential<CovidCredential>>) {
		guard let holderAddress = holderAddress else {
			completion(.failure(.underlying(error: TangemIdError.noHolderInformation)))
			return
		}
		guard let keypair = Secp256k1Utils.generateKeyPair() else {
			completion(.failure(.underlying(error: TangemIdError.failedToReceiveCredentialInformation)))
			return
		}
		let issuerAddress = ethBlockchain.makeAddress(from: keypair.publicKey)
		do {
			let covidCreds = try credentialCreator.createCovidCredentials(issuerDidAddress: issuerAddress, holderEthereumAddress: holderAddress)
			
			
			let proofHashTuplet = try proofCreator.createProof(for: covidCreds, issuerWalletAddress: issuerAddress)
			covidCreds.proof = proofHashTuplet.0
			let covidHash = proofHashTuplet.1
			
			if let signature = Secp256k1Utils.sign(covidHash, with: keypair.privateKey),
			   let str = String(data: signature, encoding: .utf8) {
				covidCreds.proof?.jws = str
			}
			
			writeCovidCredentialOnCard(credential: covidCreds, completion: completion)
		} catch {
			completion(.failure(.underlying(error: TangemIdError.failedToReceiveCredentialInformation)))
		}
	}
	
	private func writeCovidCredentialOnCard(credential: VerifiableCredential, completion: @escaping CompletionResult<HolderCredential<CovidCredential>>) {
		let cbor = credential.cborData()
		let task = WriteIssuerFilesTask(files: [cbor], issuerKeys: TangemIdUtils.signerKeys, writeSettings: [])
		tangemSdk.startSession(with: task, initialMessage: IdMessages.scanHolderCard) { (result) in
			switch result {
			case .success(let response):
				let indices = response.filesIndices
				var json = ""
				guard indices.count == 1 else {
					completion(.failure(.underlying(error: TangemIdError.failedToCreateJsonRepresentation)))
					return
				}
				if case let .success(jsonRepresentation) = self.createJson(for: credential) {
					json = jsonRepresentation
				}
				let covidCreds = HolderCredential<CovidCredential>(credentials: CovidCredential(isCovidPositive: false), file: File(fileIndex: indices[0], fileSettings: .public, fileData: cbor), json: json)
				completion(.success(covidCreds))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func changePasscode(completion: @escaping CompletionResult<SetPinResponse>) {
		tangemSdk.changePin2(initialMessage: IdMessages.scanHolderCard, completion: completion)
	}
	
}

extension TangemIdHolder: CredentialJsonPrinter {}
