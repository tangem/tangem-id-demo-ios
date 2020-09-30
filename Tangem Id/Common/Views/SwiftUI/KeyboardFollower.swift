//
//  KeyboardFollower.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

final class KeyboardFollower : ObservableObject {
	@Published var keyboardHeight: CGFloat = 0
	
	func subscribe() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisibilityChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	func unsubscribe() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	@objc func keyboardVisibilityChanged(_ notification: Notification) {
		guard
			let userInfo = notification.userInfo,
			let keyboardBeginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
			let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
			else { return }
		let visible = keyboardBeginFrame.minY > keyboardEndFrame.minY
		keyboardHeight = visible ? keyboardEndFrame.height : 0
	}
}
