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
	
	var titleStr: String {
		title.stringValue()
	}
}

extension LocalizedStringKey {
	var stringKey: String {
		let description = "\(self)"
		
		let components = description.components(separatedBy: "key: \"")
			.map { $0.components(separatedBy: "\",") }
		
		return components[1][0]
	}
}

extension String {
	static func localizedString(for key: String,
								locale: Locale = .current) -> String {
		let language = locale.languageCode
		let bundle: Bundle
		if let bundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
		   let targetBundle = Bundle(path: bundlePath)
		   {
			bundle = targetBundle
		} else {
			bundle = Bundle.main
		}
		let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
		
		return localizedString
	}
}

extension LocalizedStringKey {
	func stringValue(locale: Locale = .current) -> String {
		return .localizedString(for: self.stringKey, locale: locale)
	}
}

