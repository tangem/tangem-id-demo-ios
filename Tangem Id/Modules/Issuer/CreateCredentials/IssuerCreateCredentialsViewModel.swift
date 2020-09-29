//
//  IssuerCreateCredentialsViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine

extension Gender {
	static var genderSegments: [SegmentData] {
		allCases.filter { $0 != .notSelected }.map {
			SegmentData(title: $0.title, selectionIndex: $0.rawValue)
		}
	}
}

class IssuerCreateCredentialsViewModel: ObservableObject {
	
	private var selectedGender: Gender = .notSelected
	
	var availableGenders: [SegmentData] = Gender.genderSegments
	@Published var selectedGenderIndex: Int = -1
	
	private let moduleAssembly: ModuleAssemblyType
	
	init(moduleAssembly: ModuleAssemblyType) {
		self.moduleAssembly = moduleAssembly
	}
	
	func selectGender(at index: Int) {
		selectedGenderIndex = index
		if let gender = Gender(rawValue: index) {
			selectedGender = gender
		}
	}
	
}
