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
	
	@Binding var selectedIndex: Int
	
	var index: Int
	var placeholder: String
	var isWithClearButton: Bool = true
	var keyType: UIKeyboardType
	var returnKeyType: UIReturnKeyType
	
	var textChangeAction: ((String) -> Void)?
	
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		textField.delegate = context.coordinator
		textField.keyboardType = keyType
		textField.returnKeyType = returnKeyType
		textField.clearButtonMode = isWithClearButton ? .whileEditing : .never
		textField.addDoneButton()
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TextFieldUI>) {
		if selectedIndex == index {
			uiView.becomeFirstResponder()
		}
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
		
		func textFieldShouldReturn(_ textField: UITextField) -> Bool {
			if parent.returnKeyType == .done {
				textField.resignFirstResponder()
				return true
			}
			parent.selectedIndex = parent.index + 1
			return true
		}
		
		func textFieldDidEndEditing(_ textField: UITextField) {
			parent.selectedIndex = -1
		}
		
	}
}

struct TextFieldWithClearButton: View {
	
	var selectedIndex: Binding<Int>
	
	let index: Int
	let placeholder: String
	let isWithClearButton: Bool
	let keyboardType: UIKeyboardType
	let returnKeyType: UIReturnKeyType
	
	var textChangeAction: ((String) -> Void)?
	
	init(selectedIndex: Binding<Int>, index: Int, placeholder: String, isWithClearButton: Bool = true, keyboardType: UIKeyboardType = .default, returnKeyType: UIReturnKeyType, textChangeAction: ((String) -> Void)?) {
		self.selectedIndex = selectedIndex
		self.index = index
		self.placeholder = placeholder
		self.isWithClearButton = isWithClearButton
		self.keyboardType = keyboardType
		self.returnKeyType = returnKeyType
		self.textChangeAction = textChangeAction
	}

	var body: some View {
		VStack {
			TextFieldUI(selectedIndex: selectedIndex,
						index: index,
						placeholder: placeholder,
						isWithClearButton: isWithClearButton,
						keyType: keyboardType,
						returnKeyType: returnKeyType,
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
			selectedIndex: .constant(0),
			index: 0,
			placeholder: "Name",
			returnKeyType: .next) { (text) in
			print(text)
		}
	}
}
