//
//  MaskedTextField.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import InputMask
import SwiftUI

struct MaskedTextField: UIViewRepresentable {
	
	var placeholder: String
	var placeholderColor: UIColor = .placeholderTextColor
	var isWithClearButton: Bool = true
	var keyType: UIKeyboardType
	var format = "[000]-[00]-[0000]"
	
	var textChangeAction: ((String) -> Void)?
	
	private let delegate = MaskedTextFieldDelegate()
	
	func makeUIView(context: Context) -> UITextField {
		delegate.primaryMaskFormat = format
		let textField = UITextField()
		textField.attributedPlaceholder = NSAttributedString(string: placeholder,
															 attributes: [.foregroundColor: placeholderColor])
		textField.delegate = delegate
		textField.keyboardType = keyType
		textField.clearButtonMode = isWithClearButton ? .whileEditing : .never
		textField.addDoneButton()
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<MaskedTextField>) {
	}
	
	func makeCoordinator() -> MaskedTextField.Coordinator {
		let coordinator = Coordinator(parent: self, mask: format)
		delegate.listener = coordinator
		return coordinator
	}
	
	class Coordinator: NSObject, MaskedTextFieldDelegateListener {
		var parent: MaskedTextField
		
		init(parent: MaskedTextField, mask: String) {
			self.parent = parent
		}
		
		func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
			parent.textChangeAction?(textField.text ?? "")
		}
	}
}
