//
//  UITextField+Done.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

extension UITextField {
	func addDoneButton(_ text: String = "Done") {
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
		let doneButton = UIBarButtonItem(title: text, style: .done, target: self, action: #selector(doneButtonTapped(button:)))
		toolBar.setItems(
			[.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton],
			animated: true
		)
		inputAccessoryView = toolBar
	}
}

extension UITextField {
	@objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
		UIApplication.endEditing()
	}
}
