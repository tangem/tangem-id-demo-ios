//
//  DemoCredentials.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

protocol DemoCredential { }

struct PhotoCredential: DemoCredential {
	let photo: Data
}

struct PersonalInfoCredential: DemoCredential {
	let name: String
	let surname: String
	let gender: String
	let dateOfBirth: String
}

struct SsnCredential: DemoCredential {
	let ssn: String
}

struct AgeOver21Credential: DemoCredential {
	let isOver21: Bool
}

struct CovidCredential: DemoCredential {
	let isCovidPositive: Bool
}
