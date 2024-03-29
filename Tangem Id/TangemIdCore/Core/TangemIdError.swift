//
//  TangemIdError.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

public enum TangemIdError: LocalizedError {
	
	case cardSdkError(sdkError: TangemSdkError)
	case youNotAuthorized
	case wrongAuthorization
	case notValidIssuerCard
	case notValidHolderCard
	case notValidCard
	case credentialSigningError(error: String)
	case readingCardError
	case failedToCreateJsonRepresentation
	case notValidCborData
	case noAvailablePublicCredentials
	case noAvailableCredentials
	case noHolderInformation
	case failedToReceiveCredentialInformation
	case cancelledWithoutError
	
	public var errorDescription: String? {
		switch self {
		case .cardSdkError(let sdkError): return sdkError.localizedDescription
		case .youNotAuthorized: return IdLocalization.Errors.youNotAuthorized
		case .wrongAuthorization: return IdLocalization.Errors.wrongAuthorization
		case .notValidIssuerCard: return IdLocalization.Errors.invalidIssuerCard
		case .notValidHolderCard: return IdLocalization.Errors.invalidHolderCard
		case .notValidCard: return IdLocalization.Errors.invalidCard
		case .credentialSigningError(let error): return error
		case .readingCardError: return IdLocalization.Errors.failedToReadIssuerCard
		case .failedToCreateJsonRepresentation: return IdLocalization.Errors.failedToCreateJsonRepresentation
		case .notValidCborData: return IdLocalization.Errors.failedToCreateCredsFromCbor
		case .noAvailablePublicCredentials: return IdLocalization.Errors.noAvailablePublicCredentialsOnCard
		case .noAvailableCredentials: return IdLocalization.Errors.noAvailableCredentialsOnCard
		case .noHolderInformation: return IdLocalization.Errors.noHolderInformation
		case .failedToReceiveCredentialInformation: return IdLocalization.Errors.failedToReceiveCredentialsInfo
		case .cancelledWithoutError: return nil
		}

	}
}
