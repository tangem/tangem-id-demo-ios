//
//  DemoCredentialFactory.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/23/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

protocol ViewCredentialFactory {
	func createVerifierViewCreds(_ files: [File]) -> Result<(creds: [VerifiableCredential], viewCreds: VerifierViewCredentials), TangemIdError>
	func createHolderViewCreds(cardId: String, files: [File]) -> Result<(creds: [VerifiableCredential], viewCreds: HolderViewCredentials), TangemIdError>
}

struct DemoCredentialFactory: ViewCredentialFactory {
	
	let imageHasher: ImageHasher
	let credentialCreator: CredentialCreator
	
	func createVerifierViewCreds(_ files: [File]) -> Result<(creds: [VerifiableCredential], viewCreds: VerifierViewCredentials), TangemIdError> {
		let creds = credentialCreator.createCredentials(from: files)
		guard creds.count > 0 else {
			return .failure(.noAvailableCredentials)
		}
		var viewCreds = VerifierViewCredentials()
		creds.forEach {
			let issuerInfo = IssuerVerificationInfo(address: $0.issuer, isTrusted: true)
			if let photoCreds = demoCredential(from: $0) as? PhotoCredential {
				viewCreds.photo = VerifierCredentials(credentials: photoCreds, issuer: issuerInfo, status: .valid)
			}
			if let personalInfoCreds = demoCredential(from: $0) as? PersonalInfoCredential {
				viewCreds.personalInfo = VerifierCredentials(credentials: personalInfoCreds, issuer: issuerInfo, status: .valid)
			}
			
			if let ssn = demoCredential(from: $0) as? SsnCredential {
				viewCreds.ssn = VerifierCredentials(credentials: ssn, issuer: issuerInfo, status: .valid)
			}
			
			if let ageOver21 = demoCredential(from: $0) as? AgeOver21Credential {
				viewCreds.ageOver21 = VerifierCredentials(credentials: ageOver21, issuer: issuerInfo, status: .valid)
			}
			
			if let covid = demoCredential(from: $0) as? CovidCredential {
				viewCreds.covid = VerifierCredentials(credentials: covid, issuer: issuerInfo, status: .valid)
			}
		}
		return .success((creds: creds, viewCreds: viewCreds))
	}
	
	func createHolderViewCreds(cardId: String, files: [File]) -> Result<(creds: [VerifiableCredential], viewCreds: HolderViewCredentials), TangemIdError> {
		let viewCreds = HolderViewCredentials(cardId: cardId)
		var credentials = [VerifiableCredential]()
		files.forEach {
			guard let creds = credentialCreator.createCredentials(from: $0) else { return }
			
			var json = ""
			if case let .success(jsonStr) = createJson(for: creds) {
				json = jsonStr
			}
			let demo = demoCredential(from: creds)
			credentials.append(creds)
			switch demo {
			case let photo as PhotoCredential:
				viewCreds.photo = HolderCredential(credentials: photo, file: $0, json: json)
			case let info as PersonalInfoCredential:
				viewCreds.personalInfo = HolderCredential(credentials: info, file: $0, json: json)
			case let ssn as SsnCredential:
				viewCreds.ssn = HolderCredential(credentials: ssn, file: $0, json: json)
			case let ageOver21 as AgeOver21Credential:
				viewCreds.ageOver21 = HolderCredential(credentials: ageOver21, file: $0, json: json)
			case let covid  as CovidCredential:
				viewCreds.covid = HolderCredential(credentials: covid, file: $0, json: json)
			default:
				credentials.removeLast()
			}
		}
		guard credentials.count > 0 else {
			return .failure(.noAvailableCredentials)
		}
		return .success((creds: credentials, viewCreds: viewCreds))
	}
	
	private func demoCredential(from creds: VerifiableCredential) -> DemoCredential? {
		
		if creds.type.contains(.TangemPhotoCredential),
		   let photoBase64 = creds.credentialSubject[PhotoCredentialSubject.CodingKeys.photo.rawValue],
		   let photoData = imageHasher.imageData(from: photoBase64) {
			return PhotoCredential(photo: photoData)
		}
		
		if creds.type.contains(.TangemPersonalInformationCredential),
		   let name = creds.credentialSubject[PersonalInformationCredential.CodingKeys.givenName.rawValue],
		   let surname = creds.credentialSubject[PersonalInformationCredential.CodingKeys.familyName.rawValue],
		   let gender = creds.credentialSubject[PersonalInformationCredential.CodingKeys.gender.rawValue],
		   let dateOfBirth = creds.credentialSubject[PersonalInformationCredential.CodingKeys.born.rawValue] {
			
			return PersonalInfoCredential(name: name, surname: surname, gender: gender, dateOfBirth: dateOfBirth)
		}
		
		if creds.type.contains(.TangemSsnCredential),
		   let ssn = creds.credentialSubject[SsnCredentialSubject.CodingKeys.ssn.rawValue] {
			
			return SsnCredential(ssn: ssn)
		}
		
		if creds.type.contains(.TangemAgeOver21Credential) {
			return AgeOver21Credential(isOver21: creds.validFrom == nil ? true : creds.validFrom! <= Date())
		}
		
		if creds.type.contains(.TangemCovidCredential) {
			let covidResultStr = creds.credentialSubject[CovidCredentialSubject.CodingKeys.result.rawValue]
			let status = CovidStatus(rawValue: covidResultStr ?? "") ?? .negative
			return CovidCredential(isCovidPositive: status == .positive)
		}
		return nil
	}
	
}

extension DemoCredentialFactory: CredentialJsonPrinter {}
