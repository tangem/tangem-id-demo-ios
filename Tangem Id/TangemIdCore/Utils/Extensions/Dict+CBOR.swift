//
//  Dict+CBOR.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/20/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftCBOR

extension Dictionary where Key == String, Value == String {
	func cborMap() -> CBOR {
		var map = [CBOR: CBOR]()
		self.forEach {
			map[CBOR.utf8String($0.key)] = CBOR.utf8String($0.value)
		}
		return CBOR.map(map)
	}
}
