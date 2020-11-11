//
//  NavigationButton.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct NavigationButton<CV: View, NL: View, Style: ButtonStyle>: View {
	internal init(action: @escaping () -> Void, isBusy: Bool, contentView: CV, navigationLink: NL, buttonStyle: Style, indicatorSettings: IndicatorSettings) {
		self.action = action
		self.isBusy = isBusy
		self.contentView = contentView
		self.navigationLink = navigationLink
		self.buttonStyle = buttonStyle
		self.indicatorSettings = indicatorSettings
	}
	
	var action: () -> Void
	var isBusy: Bool
	var contentView: CV
	var navigationLink: NL
	var buttonStyle: Style
	let indicatorSettings: IndicatorSettings
	
	var body: some View {
		Button(action: {
			if !isBusy {
				action()
			}
		}) {
			if isBusy {
				ActivityIndicator(indicatorSettings: indicatorSettings)
			} else {
				contentView
					.background(navigationLink)
			}
		}
		.buttonStyle(buttonStyle)
	}
}

extension NavigationButton where CV == Text {
	internal init(action: @escaping () -> Void, isBusy: Bool, text: LocalizedStringKey, navigationLink: NL, buttonStyle: Style, indicatorSettings: IndicatorSettings) {
		self.action = action
		self.isBusy = isBusy
		self.contentView = Text(text)
		self.navigationLink = navigationLink
		self.buttonStyle = buttonStyle
		self.indicatorSettings = indicatorSettings
	}
}
