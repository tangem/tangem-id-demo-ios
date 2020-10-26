//
//  IdLocalization.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

struct IdLocalization {
	struct Common {
		static let scanIssuerCard = "scan_issuer_card".localizedString()
		static let scanHolderCard = "scan_holder_card".localizedString()
		
		static let writeFilesHint = "write_creds_files_hint".localizedString()
		
	}
	
	struct VerificationStatus {
		static let offline = "offline".localizedString()
		static let valid = "valid".localizedString()
		static let invalid = "invalid".localizedString()
		static let revoked = "revoked".localizedString()
	}
	
	struct Errors {
		static let youNotAuthorized = "you_not_authorized".localizedString()
		static let wrongAuthorization = "wrong_authorization".localizedString()
		static let invalidIssuerCard = "invalid_issuer_card".localizedString()
		static let invalidHolderCard = "invalid_holder_card".localizedString()
		static let failedToReadIssuerCard = "failed_to_read_issuer_card".localizedString()
		static let failedToCreateJsonRepresentation = "failed_to_create_json_representation".localizedString()
		static let failedToCreateCredsFromCbor = "failed_to_create_creds_from_cbor".localizedString()
		static let noAvailableCredentialsOnCard = "no_available_credentials_on_card".localizedString()
		static let noHolderInformation = "no_holder_information".localizedString()
		static let failedToReceiveCredentialsInfo = "failed_to_receive_credentials_info".localizedString()
	}
}
