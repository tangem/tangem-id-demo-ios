//
//  IssuerCreateCredentialsViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

extension Gender {
	static var genderSegments: [SegmentData] {
		allCases.filter { $0 != .notSelected }.map {
			SegmentData(title: $0.title, selectionIndex: $0.rawValue)
		}
	}
}

class IssuerCreateCredentialsViewModel: ObservableObject, Equatable {
	
	static func == (lhs: IssuerCreateCredentialsViewModel, rhs: IssuerCreateCredentialsViewModel) -> Bool {
		lhs.dateOfBirth == rhs.dateOfBirth &&
			lhs.name == rhs.name &&
			lhs.surname == rhs.surname &&
			lhs.selectedGender == rhs.selectedGender &&
			lhs.isOver18 == rhs.isOver18
	}
	
	private var selectedGender: Gender = .notSelected
	
	var availableGenders: [SegmentData] = Gender.genderSegments
	
	@Published var photo: UIImage?
	@Published var name: String = ""
	@Published var surname: String = ""
	@Published var selectedGenderIndex: Int = -1
	@Published var dateOfBirth: Date?
	@Published var isOver18: Bool = false
	
	
	private let moduleAssembly: ModuleAssemblyType
	private let issuerManager: TangemIssuerManager
	
	init(moduleAssembly: ModuleAssemblyType, issuerManager: TangemIssuerManager) {
		self.moduleAssembly = moduleAssembly
		self.issuerManager = issuerManager
	}
	
	func selectGender(at index: Int) {
		selectedGenderIndex = index
		if let gender = Gender(rawValue: index) {
			selectedGender = gender
		}
	}
	
	func inputName(_ text: String) {
		name = text
	}
	
	func inputSurname(_ text: String) {
		surname = text
	}
	
	func inputSsn(_ text: String) {
		print("Updating ssn: \(text)")
	}
	
	func isOver18Action() {
		isOver18.toggle()
	}
	
	func loadNewPhoto(image: UIImage) {
		photo = image
	}
	
}
