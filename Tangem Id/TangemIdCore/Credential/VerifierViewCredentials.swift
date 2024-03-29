//
//  VerifierViewCredentials.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

struct VerifierCredentials<T: DemoCredential> {
	let credentials: T
	let issuer: IssuerVerificationInfo
	let status: VerificationStatus
}

struct VerifierViewCredentials {
	var photo: VerifierCredentials<PhotoCredential>?
	var personalInfo: VerifierCredentials<PersonalInfoCredential>?
	var ssn: VerifierCredentials<SsnCredential>?
	var ageOver21: VerifierCredentials<AgeOver21Credential>?
	var covid: VerifierCredentials<CovidCredential>?
	
	static var demo = VerifierViewCredentials(
		photo: VerifierCredentials<PhotoCredential>(credentials: PhotoCredential(photo: Data(base64Encoded: "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") ?? Data()),
													issuer: IssuerVerificationInfo(address: "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe", isTrusted: true),
													status: .valid),
		personalInfo: VerifierCredentials<PersonalInfoCredential>(credentials: PersonalInfoCredential(name: "Tangem",
																									  surname: "Holder",
																									  gender: "Other",
																									  dateOfBirth: "10/04/2020"),
																  issuer: IssuerVerificationInfo(address: "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe", isTrusted: true),
																  status: .valid),
		ssn: VerifierCredentials<SsnCredential>(credentials: SsnCredential(ssn: "000-56-2456"),
												issuer: IssuerVerificationInfo(address: "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe", isTrusted: true),
												status: .valid),
		ageOver21: VerifierCredentials<AgeOver21Credential>(credentials: AgeOver21Credential(isOver21: false),
															issuer: IssuerVerificationInfo(address: "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe", isTrusted: true),
															status: .valid),
		covid: VerifierCredentials<CovidCredential>(credentials: CovidCredential(isCovidPositive: false),
													issuer: IssuerVerificationInfo(address: "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe", isTrusted: true),
													status: .valid))
}
