//
//  ButtonWithSpinner.swift
//  Tangem Id
//
//  Created by Andrew Son on 11/6/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ButtonWithSpinner: View {
	
	var title: LocalizedStringKey
	var isBusy: Bool
	var action: () -> Void
	let settings: IndicatorSettings
	
	var body: some View {
		Button(action: {
			if !isBusy {
				action()
			}
		}, label: {
			if isBusy {
				ActivityIndicator(indicatorSettings: settings)
			} else {
				Text(title)
			}
		})
	}
	
}
