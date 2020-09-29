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
	var isWithClearButton: Bool = true
	var keyType: UIKeyboardType
	
	var textChangeAction: ((String) -> Void)?
	
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		textField.delegate = context.coordinator
		textField.keyboardType = keyType
		textField.clearButtonMode = isWithClearButton ? .whileEditing : .never
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
		toolBar.setItems(
			[.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton],
			animated: true
		)
		textField.inputAccessoryView = toolBar
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldUI>) {
		uiView.text = text
		textChangeAction?(text)
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
				parent.text = textField.text ?? ""
			}

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
	var isWithClearButton: Bool = true
	var keyboardType: UIKeyboardType = .default
	
	var body: some View {
		VStack {
			TextFieldUI(text: text, placeholder: placeholder, keyType: keyboardType)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
			Divider()
		}
		.padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
	}
}
