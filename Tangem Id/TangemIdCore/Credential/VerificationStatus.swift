//
//  VerificationStatus.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

enum VerificationStatus {
	case offline, valid, invalid, revoked
	
	var description: String {
		switch self {
		case .offline:
			return IdLocalization.VerificationStatus.offline
		case .valid:
			return IdLocalization.VerificationStatus.valid
		case .invalid:
			return IdLocalization.VerificationStatus.invalid
		case .revoked:
			return IdLocalization.VerificationStatus.revoked
		}
	}
	
	var color: UIColor {
		switch self {
		case .offline:
			return .offline
		case .invalid, .revoked:
			return .error
		case .valid:
			return .success
		}
	}
}
