//
//  DateFormatter+.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation

extension DateFormatter {
	
	static func formatter(_ format: String) -> DateFormatter {
		let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
	}
	
    static var yearMonthDay: DateFormatter {
        formatter("yyyy-MM-dd")
    }
	
	static var monthDayYear: DateFormatter {
		formatter("MM/dd/yyyy")
	}
}
