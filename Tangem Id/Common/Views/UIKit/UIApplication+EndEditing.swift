//
//  UIApplication+EndEditing.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

extension UIApplication {
	static func endEditing(force: Bool = true) {
		UIApplication.shared.windows.first?.endEditing(true)
	}
}
