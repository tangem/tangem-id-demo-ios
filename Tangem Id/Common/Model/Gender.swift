//
//  Gender.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

enum Gender: Int, CaseIterable {
	case notSelected = -1, male = 0, female = 1, other = 2
	
	var title: String {
		switch self {
		case .male: return "Male"
		case .female: return "Female"
		case .other: return "Other"
		case .notSelected: return "N/A"
		}
	}
}
