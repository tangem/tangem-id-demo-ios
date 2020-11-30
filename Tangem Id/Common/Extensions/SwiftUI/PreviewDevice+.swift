//
//  PreviewDevice.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//

import SwiftUI

enum PreviewDeviceType: String {
	case iPhone7 = "iPhone 7"
	case iPhone11 = "iPhone 11"
	case iPhone11Max = "iPhone 11 Pro Max"
}

extension View {
	func deviceForPreview(_ type: PreviewDeviceType) -> some View {
		self
			.previewDevice(PreviewDevice(rawValue: type.rawValue))
			.previewDisplayName(type.rawValue)
			
	}
}
