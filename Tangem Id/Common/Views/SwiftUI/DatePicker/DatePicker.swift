//
//  DatePicker.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct DatePicker: View {
	
	let placeholder: String
	
	@Binding var date: Date?
	
    var body: some View {
		VStack {
			ZStack {
				DateField(placeholder, date: $date)
				HStack {
					Spacer()
					Image(systemName: "calendar")
						.foregroundColor(Color.placeholderTextColor)
				}
			}
			Divider()
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 10)
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
		DatePicker(placeholder: "Date of Birth", date: .constant(nil))
    }
}
