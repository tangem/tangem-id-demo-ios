//
//  TangemIdVerifier.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import SwiftCBOR

typealias TangemVerifierManager = TangemIdSdk<TangemIdVerifier>
 
 final class TangemIdVerifier: ActionExecutioner {

	private let tangemSdk: TangemSdk
	private let credentialCreator: CredentialCreator
	private let imageHasher: ImageHasher
	
	private var readCredentials: [VerifiableCredential] = []
	private var viewCredentials: VerifierViewCredentials?

	init(tangemSdk: TangemSdk, credentialCreator: CredentialCreator, imageHasher: ImageHasher) {
		self.tangemSdk = tangemSdk
		self.credentialCreator = credentialCreator
		self.imageHasher = imageHasher
	}

	var executionerInfo: RoleInfo {
		VerifierRoleInfo()
	}

	func execute(action: VerifierAction) {
		switch action {
		case .readHoldersCredentials(let completion):
			readFiles(completion: completion)
		case .showCredentialsAsJson(let completion):
			createJson(for: readCredentials, completion: completion)
		}
	}

	private func readFiles(completion: @escaping CompletionResult<VerifierViewCredentials>) {
		tangemSdk.readFiles(initialMessage: Message(header: IdLocalization.Common.scanHolderCard, body: nil), readSettings: ReadFilesTaskSettings(readPrivateFiles: false)) { (result) in
			switch result {
			case .success(let response):
				self.convertFilesToCreds(response.files, completion: completion)
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	private func convertFilesToCreds(_ files: [File], completion: @escaping CompletionResult<VerifierViewCredentials>) {
		let readCredentials = credentialCreator.createCredentials(from: files)
		self.readCredentials = readCredentials
		let viewCredentials = createViewCredentials(for: readCredentials)
		self.viewCredentials = viewCredentials
		completion(.success(viewCredentials))
	}
	
	private func createViewCredentials(for readCredentials: [VerifiableCredential]) -> VerifierViewCredentials {
		var viewCreds = VerifierViewCredentials()
		readCredentials.forEach {
			let issuerInfo = IssuerVerificationInfo(address: $0.issuer, isTrusted: true)
			if $0.type.contains(.TangemPhotoCredential),
			   let photoBase64 = $0.credentialSubject[PhotoCredentialSubject.CodingKeys.photo.rawValue],
			   let photoData = imageHasher.imageData(from: photoBase64) {
				viewCreds.photo = .init(credentials: PhotoCredential(photo: photoData), issuer: issuerInfo, status: .valid)
			}
			
			if $0.type.contains(.TangemPersonalInformationCredential),
			   let name = $0.credentialSubject[PersonalInformationCredential.CodingKeys.givenName.rawValue],
			   let surname = $0.credentialSubject[PersonalInformationCredential.CodingKeys.familyName.rawValue],
			   let gender = $0.credentialSubject[PersonalInformationCredential.CodingKeys.gender.rawValue],
			   let dateOfBirth = $0.credentialSubject[PersonalInformationCredential.CodingKeys.born.rawValue] {
				
				viewCreds.personalInfo = .init(credentials: PersonalInfoCredential(name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth), issuer: issuerInfo, status: .valid)
			}
			
			if $0.type.contains(.TangemSsnCredential),
			   let ssn = $0.credentialSubject[SsnCredentialSubject.CodingKeys.ssn.rawValue] {
				
				viewCreds.ssn = .init(credentials: SsnCredential(ssn: ssn), issuer: issuerInfo, status: .valid)
			}
			
			if $0.type.contains(.TangemAgeOver21Credential) {
				viewCreds.ageOver21 = .init(credentials: AgeOver21Credential(isOver21: $0.validFrom == nil ? true : $0.validFrom! <= Date()), issuer: issuerInfo, status: .valid)
			}
			
			if $0.type.contains(.TangemCovidCredential) {
				let covidResultStr = $0.credentialSubject[CovidCredentialSubject.CodingKeys.result.rawValue]
				let status = CovidStatus(rawValue: covidResultStr ?? "") ?? .negative
				viewCreds.covid = .init(credentials: CovidCredential(isCovidPositive: status == .positive), issuer: issuerInfo, status: .valid)
			}
		}
		return viewCreds
	}
	
 }

extension TangemIdVerifier: CredentialJsonPrinter { }
