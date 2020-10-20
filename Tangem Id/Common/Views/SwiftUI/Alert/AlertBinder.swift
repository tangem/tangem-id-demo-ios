//
//  AlertBinder.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/19/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct AlertBinder: Identifiable {
	let id = UUID()
	let alert: Alert
}

extension Error {
	var alertBinder: AlertBinder {
		return AlertBinder(alert: alert)
	}
	
	var alert: Alert {
		return Alert(title: Text("common_error".localized),
					 message: Text(self.localizedDescription),
					 dismissButton: Alert.Button.default(Text("OK")))
	}
}
