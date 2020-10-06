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

class IssuerCreateCredentialsViewModel: ObservableObject, Equatable, SnackMessageDisplayable {
	
	static func == (lhs: IssuerCreateCredentialsViewModel, rhs: IssuerCreateCredentialsViewModel) -> Bool {
		lhs.dateOfBirth == rhs.dateOfBirth &&
			lhs.name == rhs.name &&
			lhs.surname == rhs.surname &&
			lhs.selectedGender == rhs.selectedGender &&
			lhs.isOver21 == rhs.isOver21
	}
	
	private var selectedGender: Gender = .notSelected
	
	var availableGenders: [SegmentData] = Gender.genderSegments
	
	@Published var photo: UIImage?
	
	@Published var selectedGenderIndex: Int = -1
	@Published var dateOfBirth: Date? {
		didSet {
			guard let birth = dateOfBirth else { return }
			let calendar = Calendar.current
			let components = calendar.dateComponents([.year], from: birth, to: Date())
			isOver21 = components.year ?? 0 >= 21
		}
	}
	@Published var isOver21: Bool = false
	
	@Published var snackMessage: SnackData = SnackData(message: "Not filled info", type: .error)
	@Published var isShowingSnack: Bool = false
	@Published var isCredentialsCreated: Bool = false
	
	private(set) var name: String = ""
	private(set) var surname: String = ""
	private(set) var ssn: String = ""
	
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
	
	func inputSsn(_ ssn: String) {
		self.ssn = ssn
	}
	
	func signEnteredInfo() {
		guard
			isDataValid(),
			let credsInput = formatCredsInput()
		else {
			showErrorSnack(message: LocalizedStrings.Snacks.issuerSomeEmptyFields)
			return
		}
		isCredentialsCreated.toggle()
		issuerManager.execute(action: .signCredentials(credsInput, { [weak self] (result) in
			
		}))
	}
	
	private func isDataValid() -> Bool {
		return photo != nil &&
			!name.isEmpty &&
			!surname.isEmpty &&
			!ssn.isEmpty &&
			selectedGender != .notSelected &&
			dateOfBirth != nil
	}
	
	private func formatCredsInput() -> CredentialInput? {
		guard
			let photo = photo,
			let dateOfBirth = dateOfBirth
		else { return nil }
		return CredentialInput(photo: photo,
							   name: name,
							   surname: surname,
							   gender: selectedGender.titleStr,
							   dateOfBirth: dateOfBirth,
							   ssn: ssn,
							   isOver21: isOver21)
	}
	
}
