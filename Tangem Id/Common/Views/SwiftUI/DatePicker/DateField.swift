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

    private var placeholder: String
    private let formatter: DateFormatter
    private let textField: DateTextField
	
    init<S>(_ title: S, date: Binding<Date?>, formatter: DateFormatter = .monthDayYear) where S: StringProtocol {
		self.placeholder = String(title)
        self._date = date

        self.textField = DateTextField(date: date)
		textField.addDoneButton()
        self.formatter = formatter
    }

    func makeUIView(context: UIViewRepresentableContext<DateField>) -> UITextField {
		textField.attributedPlaceholder = NSAttributedString(string: placeholder,
															 attributes: [.foregroundColor: UIColor.placeholderTextColor])
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<DateField>) {
        if let date = date {
            uiView.text = formatter.string(from: date)
        }
    }

}
