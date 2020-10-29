//
//  DateField.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct DateField: UIViewRepresentable {
    @Binding var date: Date?
	@Binding var selectedIndex: Int

	private let index: Int
    private var placeholder: String
    private let formatter: DateFormatter
    private let textField: DateTextField
	
	init(_ title: String, date: Binding<Date?>, selectedIndex: Binding<Int>, index: Int, formatter: DateFormatter = .monthDayYear) {
		self.placeholder = title
        self._date = date
		self._selectedIndex = selectedIndex

		self.index = index
        textField = DateTextField(date: date)
		textField.addDoneButton()
        self.formatter = formatter
    }

    func makeUIView(context: UIViewRepresentableContext<DateField>) -> UITextField {
		textField.attributedPlaceholder = NSAttributedString(string: placeholder,
															 attributes: [.foregroundColor: UIColor.placeholderTextColor])
		textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<DateField>) {
        if let date = date {
            uiView.text = formatter.string(from: date)
        }
		if selectedIndex == index {
			uiView.becomeFirstResponder()
		}
    }
	
	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	class Coordinator: NSObject, UITextFieldDelegate {
		var parent: DateField
		
		init(parent: DateField) {
			self.parent = parent
		}
		
		func textFieldDidEndEditing(_ textField: UITextField) {
			parent.selectedIndex = -1
		}
	}

}
