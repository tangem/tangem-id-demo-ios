//
//  LocalizationKeys.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Foundation


/// Used for receiving LocalizedStringKey (SwiftUI version)
struct LocalizationKeys {
	struct Modules {
		struct RoleSelector {
			static let descriptionText: LocalizedStringKey = "role_selector_rescription"
		}
		struct Issuer {
			static let didIssuerAddress: LocalizedStringKey = "did_issuer_address"
			static let photo: LocalizedStringKey = "photo"
			static let personalInfo: LocalizedStringKey = "personal_info"
		}
	}
	
	struct NavigationBar {
		static let issueCredentials: LocalizedStringKey = "issue_credentials"
	}
	struct Common {
		static let issuer: LocalizedStringKey = "issuer"
		static let verifier: LocalizedStringKey = "verifier"
		static let holder: LocalizedStringKey = "holder"
		static let addPhoto: LocalizedStringKey = "add_photo"
		static let dateOfBirth: LocalizedStringKey = "date_of_birth"
		static let name: LocalizedStringKey = "name"
		static let surname: LocalizedStringKey = "surname"
		static let ssn: LocalizedStringKey = "ssn"
		static let ageOver18: LocalizedStringKey = "age_over_18"
		
		static let male: LocalizedStringKey = "male"
		static let female: LocalizedStringKey = "female"
		static let other: LocalizedStringKey = "other"
	}
}

/// Contain already localized strings
struct LocalizedStrings {
	struct Common {
		static let name = "name".localizedString()
		static let surname = "surname".localizedString()
		static let dateOfBirth = "date_of_birth".localizedString()
	}
}

extension String {
	func toLocaleKey() -> LocalizedStringKey {
		LocalizedStringKey(self)
	}
}

extension String {
	func localizedString(locale: Locale = .current) -> String {
        let localizedString = NSLocalizedString(self, comment: "")
        return localizedString
    }
}
