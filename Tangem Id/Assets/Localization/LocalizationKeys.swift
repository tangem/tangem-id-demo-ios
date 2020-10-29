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
			static let signCredentials: LocalizedStringKey = "sign_credentials"
			static let writeToCardCredentials: LocalizedStringKey = "write_to_card_credentials"
			static let credentialsSignedWarningTitle: LocalizedStringKey = "credentials_signed_title"
			static let credentialsSignedWarningBody: LocalizedStringKey = "credentials_signed_body"
		}
		
		struct Verifier {
			static let status: LocalizedStringKey = "status"
			static let issuedBy: LocalizedStringKey = "issued_by"
			static let issuer: LocalizedStringKey = "issuer"
			static let trusted: LocalizedStringKey = "trusted"
			static let unknown: LocalizedStringKey = "unknown"
		}
		
		struct Holder {
			static let personalCard: LocalizedStringKey = "personal_card"
			static let requestNewCreds: LocalizedStringKey = "request_new_credentials"
			static let saveChanges: LocalizedStringKey = "save_changes"
			static let jsonRepresentation: LocalizedStringKey = "json_representation"
			static let shareJson: LocalizedStringKey = "share_json"
			static let credentials: LocalizedStringKey = "credentials"
			static let selectAction: LocalizedStringKey = "select_settings_action"
			static let changePasscode: LocalizedStringKey = "change_passcode"
		}
	}
	
	struct NavigationBar {
		static let issuerDetails: LocalizedStringKey = "issuer_details"
		static let issueCredentials: LocalizedStringKey = "issue_credentials"
		static let idValidator: LocalizedStringKey = "verifier_navigation"
	}
	
	struct Common {
		static let issuer: LocalizedStringKey = "issuer"
		static let verifier: LocalizedStringKey = "verifier"
		static let holder: LocalizedStringKey = "holder"
		static let iIssuer: LocalizedStringKey = "i_am_issuer"
		static let iVerifier: LocalizedStringKey = "i_am_verifier"
		static let iHolder: LocalizedStringKey = "i_am_holder"
		
		static let photo: LocalizedStringKey = "photo"
		static let personalInfo: LocalizedStringKey = "personal_info"
		static let gender: LocalizedStringKey = "gender"
		static let addPhoto: LocalizedStringKey = "add_photo"
		static let dateOfBirth: LocalizedStringKey = "date_of_birth"
		static let name: LocalizedStringKey = "name"
		static let surname: LocalizedStringKey = "surname"
		static let ssn: LocalizedStringKey = "ssn"
		static let ageOver21: LocalizedStringKey = "age_over_21"
		static let covidImmunity: LocalizedStringKey = "covid_immunity"
		
		static let valid: LocalizedStringKey = "valid"
		
		static let share: LocalizedStringKey = "share"
		static let hide: LocalizedStringKey = "hide"
		
		static let male: LocalizedStringKey = "male"
		static let female: LocalizedStringKey = "female"
		static let other: LocalizedStringKey = "other"
		
		static let showJsonCreds: LocalizedStringKey = "show_json_creds"
		
		static let dismiss: LocalizedStringKey = "dismiss"
		static let stay: LocalizedStringKey = "stay"
		static let cancel: LocalizedStringKey = "cancel"
		static let settings: LocalizedStringKey = "settings"
		
		static let cameraPermissionDenied: LocalizedStringKey = "camera_permission_denied"
		static let accessDenied: LocalizedStringKey = "access_denied"
	}
}

/// Contain already localized strings
struct LocalizedStrings {
	struct Common {
		static let name = "name".localizedString()
		static let surname = "surname".localizedString()
		static let dateOfBirth = "date_of_birth".localizedString()
	}
	struct Snacks {
		static let issuerSomeEmptyFields = "issuer_empty_fields".localizedString()
		static let credentialsSignedSuccess = "creds_signed".localizedString()
		static let credentialsSavedOnCard = "creds_saved_on_card".localizedString()
		
		static let failedToSignCredentials = "failed_to_sign_error".localizedString()
		static let failedToWriteCredentials = "failed_to_write_creds_error".localizedString()
		
		static let alreadyHasCredential = "already_has_credential".localizedString()
		
		static let passcodeChanged = "passcode_changed".localizedString()
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
