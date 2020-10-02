//
//  CardValidator.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

protocol CardValidator {
	var validCards: [ProductMask] { get }
}
