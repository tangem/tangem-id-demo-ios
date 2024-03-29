//
//  DateTextField.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit
import SwiftUI

class DateTextField: UITextField {
	
    @Binding var date: Date?

    init(date: Binding<Date?>) {
        self._date = date
        super.init(frame: .zero)

        if let date = date.wrappedValue {
            self.datePickerView.date = date
        }

        self.datePickerView.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.inputView = datePickerView
        self.tintColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//		   if action == #selector(UIResponderStandardEditActions.paste(_:)) {
			   return false
//		   }
//		   return super.canPerformAction(action, withSender: sender)
	  }

    private lazy var datePickerView: UIDatePicker = {
        let datePickerView = UIDatePicker()
		if #available(iOS 13.4, *) {
			datePickerView.preferredDatePickerStyle = .wheels
		}
        datePickerView.datePickerMode = .date
		datePickerView.maximumDate = Date()
        return datePickerView
    }()

    @objc func dateChanged(_ sender: UIDatePicker) {
        self.date = sender.date
    }
}
