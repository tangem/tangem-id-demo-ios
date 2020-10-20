//
//  Array+CBOR.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/20/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftCBOR

extension Array where Element == String {
	func cborArray() -> CBOR {
		CBOR.array(map { CBOR.utf8String($0) })
	}
}
