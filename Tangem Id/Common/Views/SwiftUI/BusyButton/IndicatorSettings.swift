//
//  BusyButtonIndicatorSettings.swift
//  Tangem Id
//
//  Created by Andrew Son on 11/6/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

struct IndicatorSettings {
	let indicatorStyle: UIActivityIndicatorView.Style
	let color: UIColor
	
	static func settingsForButtonStyle(_ style: ButtonColorStyle) -> IndicatorSettings {
		switch style {
		case .blue:
			return IndicatorSettings(indicatorStyle: .medium, color: .white)
		case .white:
			return IndicatorSettings(indicatorStyle: .medium, color: .tangemBlue)
		case .transparentBlue:
			return IndicatorSettings(indicatorStyle: .medium, color: .red)
		}
	}
}
