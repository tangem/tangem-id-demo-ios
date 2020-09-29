//
//  TextFieldWithClearButton.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit
import SwiftUI

struct TextFieldUI: UIViewRepresentable {
	@Binding var text: String
	
	var placeholder: String
	
	var keyType: UIKeyboardType
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		textField.keyboardType = keyType
		textField.clearButtonMode = .whileEditing
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
		toolBar.setItems(
			[.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton],
			animated: true
		)
		textField.inputAccessoryView = toolBar
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.text = text
	}
}

extension UITextField {
	@objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
	   self.resignFirstResponder()
	}
}

struct TextFieldWithClearButton: View {
	
	var text: Binding<String>
	let placeholder: String
	
	var body: some View {
		VStack {
			TextFieldUI(text: text, placeholder: placeholder, keyType: .default)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
			Divider()
		}
		.padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
	}
}
