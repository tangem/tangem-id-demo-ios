//
//  ByteCountFormatter+.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/3/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

extension ByteCountFormatter {
	static var byteCounter: ByteCountFormatter = {
		let formatter = ByteCountFormatter()
		formatter.allowedUnits = [.useKB, .useMB]
		return formatter
	}()
	static func string(for byteCount: Int?) -> String {
		guard let count = byteCount else {
			return "Undefined byte count"
		}
		return byteCounter.string(fromByteCount: Int64(count))
	}
}
