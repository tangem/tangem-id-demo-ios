//
//  TangemIdError.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

enum TangemIdError: Error, Hashable {
	
	case cardSdkError(sdkError: String)
	case youNotAuthorized
	case wrongAuthorization
	case notValidIssuerCard
	case readingCardError
	
	var localizedDescription: String {
		switch self {
		case .cardSdkError(let sdkError): return sdkError
		case .youNotAuthorized: return IdLocalization.Errors.youNotAuthorized
		case .wrongAuthorization: return IdLocalization.Errors.wrongAuthorization
		case .notValidIssuerCard: return IdLocalization.Errors.invalidIssuerCard
		case .readingCardError: return IdLocalization.Errors.failedToReadIssuerCard
		}
	}
}
