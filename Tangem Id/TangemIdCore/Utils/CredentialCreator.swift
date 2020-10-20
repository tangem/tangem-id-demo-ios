//
//  CredentialFactory.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk
import BlockchainSdk
import CryptoSwift

enum CredentialCreatorType {
	case demo
}

protocol CredentialCreatorFactoryType {
	func makeCreator(_ type: CredentialCreatorType) -> CredentialCreator
}

struct CredentialCreatorFactory: CredentialCreatorFactoryType {
	func makeCreator(_ type: CredentialCreatorType) -> CredentialCreator {
		switch type {
		case .demo:
			return DemoCredentialCreator(imageHasher: JpegSha3ImageHasher())
		}
	}
}

protocol CredentialCreator: class {
	func createCredentialsToSign(issuerDidAddress: String, input: CredentialInput, holderEthereumAddress: String) throws -> [VerifiableCredential]
}

class DemoCredentialCreator {
	
	enum DemoCredsType {
		case photo, personalInfo, ssn, isOver21
		
		var verifiableCredsTypes: [VerifiableCredentialType] {
			[.VerifiableCredential, .TangemEthCredential, self.credUniqueType]
		}
		
		var credUniqueType: VerifiableCredentialType {
			switch self {
			case .photo: return .TangemPhotoCredential
			case .personalInfo: return .TangemPersonalInformationCredential
			case .ssn: return .TangemSsnCredential
			case .isOver21: return .TangemAgeOver21Credential
			}
		}
	}
	
	private let blockchain = Blockchain.ethereum(testnet: false)
	private let imageHasher: ImageHasher
	
	internal init(imageHasher: ImageHasher) {
		self.imageHasher = imageHasher
	}
	
	private func verifiableCredential(from issuerAddress: String, for subject: DictConvertible, credType: DemoCredsType) -> VerifiableCredential {
		VerifiableCredential(
			context: IdConstants.jsonLdDefaultContext,
			type: credType.verifiableCredsTypes,
			credentialSubject: subject.toStringDict(),
			issuer: issuerAddress,
			issuanceDate: Date().iso8601withFractionalSeconds
		)
	}
	
	private func photoCreds(issuerAddress: String, subjectAddress: String) -> VerifiableCredential {
		let photoCreds = PhotoCredentialSubject(id: subjectAddress, photo: imageHasher.base64)
		return verifiableCredential(from: issuerAddress, for: photoCreds, credType: .photo)
	}
	
	private func personalInfoCreds(issuerAddress: String, subjectAddress: String, input: CredentialInput) -> VerifiableCredential {
		let personalInfoCreds = PersonalInformationCredential(id: subjectAddress, input: input, photoHash: imageHasher.hash)
		return verifiableCredential(from: issuerAddress, for: personalInfoCreds, credType: .personalInfo)
	}
	
	private func ssnCreds(issuerAddress: String, subjectAddress: String, input: CredentialInput) -> VerifiableCredential {
		let ssnCreds = SsnCredentialSubject(id: subjectAddress, ssn: input.ssn, photoHash: imageHasher.hash)
		return verifiableCredential(from: issuerAddress, for: ssnCreds, credType: .ssn)
	}
	
	private func ageOver21Creds(issuerAddress: String, subjectAddress: String, input: CredentialInput) -> VerifiableCredential {
		let ageOverCreds = AgeOver21CredentialSubject(id: subjectAddress, photoHash: imageHasher.hash)
		let creds = verifiableCredential(from: issuerAddress, for: ageOverCreds, credType: .isOver21)
		let calendar = Calendar.current
		if let over21Date = calendar.date(byAdding: .year, value: 21, to: input.dateOfBirth),
		   over21Date > Date() {
			creds.validFrom = over21Date
		}
		return creds
	}
	
}

extension DemoCredentialCreator: CredentialCreator {
	func createCredentialsToSign(issuerDidAddress: String, input: CredentialInput, holderEthereumAddress: String) throws -> [VerifiableCredential] {
		let didHolder = IdConstants.didPrefix + holderEthereumAddress
		imageHasher.hash(image: input.photo, withQuality: 0.1)
		let credentials = [
			photoCreds(issuerAddress: issuerDidAddress, subjectAddress: didHolder),
			personalInfoCreds(issuerAddress: issuerDidAddress, subjectAddress: didHolder, input: input),
			ssnCreds(issuerAddress: issuerDidAddress, subjectAddress: didHolder, input: input),
			ageOver21Creds(issuerAddress: issuerDidAddress, subjectAddress: didHolder, input: input)
		]
		
		let jsonEncoder = JSONEncoder()
		jsonEncoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601withMilliSeconds)
		var credsHashes: [Data] = []
		do {
			try credsHashes = credentials
				.map { try jsonEncoder.encode($0) }
				.map { $0.sha3(.sha512) }
		}
		let singleHash = credsHashes.reduce(Data(fromArray: [0]), { $0 + $1 })
		let ethCredsStatus = blockchain.makeAddress(from: singleHash)
		credentials.forEach { $0.ethCredentialStatus = ethCredsStatus }
		
		return credentials
	}
}
