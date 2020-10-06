//
//  SnackMessageDisplayable.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/4/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

protocol SnackMessageDisplayable: class {
	var snackMessage: SnackData { get set }
	var isShowingSnack: Bool { get set }
}

extension SnackMessageDisplayable {
	func showSnack(message: String, type: SnackType) {
		snackMessage = SnackData(message: message, type: type)
		isShowingSnack = true
	}
	
	func showErrorSnack(message: String) {
		showSnack(message: message, type: .error)
	}
	
	func showInfoSnack(message: String) {
		showSnack(message: message, type: .info)
	}
}
