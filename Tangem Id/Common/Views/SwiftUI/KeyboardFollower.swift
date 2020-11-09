//
//  KeyboardFollower.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine

final class KeyboardFollower : ObservableObject {
	@Published var keyboardHeight: CGFloat = 0
	@Published var isKeyboardVisible: Bool = false
	
	private var bag: Set<AnyCancellable> = []
	
	func subscribe() {
		let center = NotificationCenter.default
		center.publisher(for: UIApplication.keyboardWillShowNotification)
			.sink(receiveValue: { _ in
				print("Receive will show keyboard notif")
				self.isKeyboardVisible = true
			})
			.store(in: &bag)
		center.publisher(for: UIApplication.keyboardWillHideNotification)
			.sink(receiveValue: { _ in
				print("Receive will hide keyboard notif")
				self.isKeyboardVisible = false
			})
			.store(in: &bag)
		center.publisher(for: UIApplication.keyboardWillChangeFrameNotification)
			.sink(receiveValue: { notif in
				print("Receive will change frame keyboard notif")
				self.keyboardVisibilityChanged(notif)
			})
			.store(in: &bag)
//		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { _ in self.isKeyboardVisible = true })
//		NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { _ in self.isKeyboardVisible = false })
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardVisibilityChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
	}
	
	func unsubscribe() {
		isKeyboardVisible = false
		bag.removeAll()
//		NotificationCenter.default.removeObserver(self)
	}
	
	@objc func keyboardVisibilityChanged(_ notification: Notification) {
		guard
			let userInfo = notification.userInfo,
//			let keyboardBeginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
			let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
			else { return }
		print(keyboardEndFrame)
//		let visible = keyboardEndFrame.minY <= UIScreen.main.bounds.height - 40
		keyboardHeight = keyboardEndFrame.height
	}
}
