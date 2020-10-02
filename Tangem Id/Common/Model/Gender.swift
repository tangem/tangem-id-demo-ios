//
//  Gender.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

enum Gender: Int, CaseIterable {
	case notSelected = -1, male = 0, female = 1, other = 2
	
	var title: LocalizedStringKey {
		switch self {
		case .male: return LocalizationKeys.Common.male
		case .female: return LocalizationKeys.Common.female
		case .other: return LocalizationKeys.Common.other
		case .notSelected: return "N/A"
		}
	}
}
