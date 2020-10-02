//
//  HiddenSystemNavigation.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct HiddenSystemNavigation: ViewModifier {
	func body(content: Content) -> some View {
		content
			.navigationBarTitle("")
			.navigationBarHidden(true)
			.navigationBarBackButtonHidden(true)
	}
}
