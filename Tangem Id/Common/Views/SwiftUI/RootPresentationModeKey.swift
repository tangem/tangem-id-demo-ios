//
//  RootPresentationModeKey.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/19/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct RootPresentationModeKey: EnvironmentKey {
	static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
	var rootPresentationMode: Binding<RootPresentationMode> {
		get { return self[RootPresentationModeKey.self] }
		set { self[RootPresentationModeKey.self] = newValue }
	}
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
	
	public mutating func dismiss() {
		self.toggle()
	}
}
