//
//  String+CBOR.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/20/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftCBOR

extension String {
	func cbor() -> CBOR {
		.utf8String(self)
	}
}
