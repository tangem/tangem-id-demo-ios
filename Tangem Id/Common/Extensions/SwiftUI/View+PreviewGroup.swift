//
//  View+PreviewGroup.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

extension View {
	func previewGroup() -> some View {
		Group {
			self.deviceForPreview(.iPhone7)
			self.deviceForPreview(.iPhone11)
			self.deviceForPreview(.iPhone11Max)
		}
	}	
}
