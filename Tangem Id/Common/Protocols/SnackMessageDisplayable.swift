//
//  SnackMessageDisplayable.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/4/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

protocol SnackMessageDisplayable: class {
	var snackMessage: SnackData { get set }
	var isShowingSnack: Bool { get set }
}

extension SnackMessageDisplayable {
	func showSnack(message: String, type: SnackType) {
		DispatchQueue.main.async {
			self.snackMessage = SnackData(message: message, type: type)
			self.isShowingSnack = true
		}
	}
	
	func showErrorSnack(message: String) {
		showSnack(message: message, type: .error)
	}
	
	func showInfoSnack(message: String) {
		showSnack(message: message, type: .info)
	}
	
	func showErrorSnack(error: TangemSdkError) {
		guard shouldDisplaySnack(error: error) else { return }
		
		showErrorSnack(message: error.localizedDescription)
	}
	
	func showErrorSnack(error: TangemSdkError, withMessage message: String) {
		guard shouldDisplaySnack(error: error) else { return }
		
		showErrorSnack(message: message)
	}
	
	private func shouldDisplaySnack(error: TangemSdkError) -> Bool {
		if case .userCancelled = error { return false }
		
		if case .busy = error {
			showInfoSnack(message: LocalizedStrings.Snacks.nfcIsBusy)
			return false
		}
		
		if case .nfcStuck = error {
			showInfoSnack(message: LocalizedStrings.Snacks.nfcReadyToUse)
			return false
		}
		
		if case .underlying(let idError) = error,
		   case TangemIdError.cancelledWithoutError = idError { return false }
		
		return true
	}
}
