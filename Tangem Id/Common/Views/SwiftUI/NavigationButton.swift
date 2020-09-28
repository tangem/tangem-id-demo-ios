//
//  NavigationButton.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct NavigationButton<CV: View, NL: View, Style: ButtonStyle>: View {
	internal init(action: @escaping () -> Void, contentView: CV, navigationLink: NL, buttonStyle: Style) {
		self.action = action
		self.contentView = contentView
		self.navigationLink = navigationLink
		self.buttonStyle = buttonStyle
	}
	
	internal init(action: @escaping () -> Void, text: String, navigationLink: NL, buttonStyle: Style) where CV == Text {
		self.action = action
		self.contentView = Text(text)
		self.navigationLink = navigationLink
		self.buttonStyle = buttonStyle
	}
	
	var action: () -> Void
	var contentView: CV
	var navigationLink: NL
	var buttonStyle: Style
	
	var body: some View {
		Button(action: action) {
			contentView
				.background(navigationLink)
		}
		.buttonStyle(buttonStyle)
	}
}
