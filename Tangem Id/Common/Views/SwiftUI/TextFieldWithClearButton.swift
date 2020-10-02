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
	
	var placeholder: String
	var isWithClearButton: Bool = true
	var keyType: UIKeyboardType
	
	var textChangeAction: ((String) -> Void)?
	
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		textField.delegate = context.coordinator
		textField.keyboardType = keyType
		textField.clearButtonMode = isWithClearButton ? .whileEditing : .never
		textField.addDoneButton()
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldUI>) {
//		textChangeAction?(uiView.text ?? "")
	}
	
	func makeCoordinator() -> TextFieldUI.Coordinator {
			Coordinator(parent: self)
		}

		class Coordinator: NSObject, UITextFieldDelegate {
			var parent: TextFieldUI

			init(parent: TextFieldUI) {
				self.parent = parent
			}
			
			func textFieldDidChangeSelection(_ textField: UITextField) {
				parent.textChangeAction?(textField.text ?? "")
			}

		}
}

extension UITextField {
	@objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
	   self.resignFirstResponder()
	}
}

struct TextFieldWithClearButton: View {
	
	let placeholder: String
	let isWithClearButton: Bool
	let keyboardType: UIKeyboardType
	
	var textChangeAction: ((String) -> Void)?
	
	init(placeholder: String, isWithClearButton: Bool = true, keyboardType: UIKeyboardType = .default, textChangeAction: ((String) -> Void)?) {
		self.placeholder = placeholder
		self.isWithClearButton = isWithClearButton
		self.keyboardType = keyboardType
		self.textChangeAction = textChangeAction
	}
	
	var body: some View {
		VStack {
			TextFieldUI(placeholder: placeholder, isWithClearButton: isWithClearButton, keyType: keyboardType,
						textChangeAction: textChangeAction)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
			Divider()
		}
		.padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
	}
}

struct TextFieldWithClearButton_Previews: PreviewProvider {
	static var previews: some View {
		TextFieldWithClearButton(
			placeholder: "Name"
		)
		{ (text) in
				print(text)
		}
	}
}
