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
	}
	
	struct Errors {
		static let youNotAuthorized = "you_not_authorized".localizedString()
		static let wrongAuthorization = "wrong_authorization".localizedString()
		static let invalidIssuerCard = "invalid_issuer_card".localizedString()
		static let failedToReadIssuerCard = "failed_to_read_issuer_card".localizedString()
	}
}
