//
//  ClickableRow.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ClickableRowWithCheckbox: View {
	
	var isSelected: Bool
	var action: () -> Void
	var title: String = "Valid"
	var isInteractionEnabled: Bool = true
	
    var body: some View {
		HStack {
			Text(title)
				.font(.credentialCardContent)
				.foregroundColor(Color.tangemBlack)
			Spacer()
				.background(Color.red)
			Checkbox(isSelected: isSelected)
		}
		.padding(.horizontal)
		.padding(.bottom, 16)
		.background(Color.white)
		.onTapGesture(perform: {
			guard self.isInteractionEnabled else { return }
			self.action()
		})
    }
}

struct ClickableRow_Previews: PreviewProvider {
	@State static var isSelected: Bool = true
	
    static var previews: some View {
		ClickableRowWithCheckbox(isSelected: isSelected, action: {
			isSelected.toggle()
		})
    }
}
