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
import TangemSdk

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
	@Published var shouldDismissToRoot: Bool = false
	
	@Published var jsonRepresentation: String = ""
	@Published var isShowingJson: Bool = false
	@Published var isNfcBusy: Bool = false
	
	var doesFormHasInput: Bool {
		!name.isEmpty ||
			!surname.isEmpty ||
			!ssn.isEmpty ||
			photo != nil ||
			dateOfBirth != nil ||
			selectedGenderIndex >= 0
	}
	
	private(set) var name: String = ""
	private(set) var surname: String = ""
	private(set) var ssn: String = ""
	
	private var selectedGender: Gender = .notSelected
	
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
		UIApplication.endEditing()
		guard
			isDataValid(),
			let credsInput = formatCredsInput()
		else {
			showErrorSnack(message: LocalizedStrings.Snacks.issuerSomeEmptyFields)
			return
		}
		isNfcBusy = true
		issuerManager.execute(action: .signCredentials(credsInput, { [weak self] (result) in
			switch result {
			case .success:
				self?.showSnack(message: LocalizedStrings.Snacks.credentialsSignedSuccess, type: .info)
				self?.isCredentialsCreated = true
			case .failure(let error):
				self?.showErrorSnack(error: error, withMessage: String(format: LocalizedStrings.Snacks.failedToSignCredentials, error.localizedDescription))
			}
			self?.isNfcBusy = false
		}))
	}
	
	func writeCredentialsToCard() {
		isNfcBusy = true
		issuerManager.execute(action: .saveCredentialsToCard { [weak self] (result) in
			switch result {
			case .success:
				self?.showInfoSnack(message: LocalizedStrings.Snacks.credentialsSavedOnCard)
				self?.shouldDismissToRoot = true
			case .failure(let error):
				self?.showErrorSnack(error: error, withMessage: String(format: LocalizedStrings.Snacks.failedToWriteCredentials, error.localizedDescription))
			}
			self?.isNfcBusy = false
		})
	}
	
	func showJsonRepresentation() {
		issuerManager.execute(action: .showCredentialsAsJson({ (result) in
			switch result {
			case .success(let json):
				self.jsonRepresentation = json
				self.isShowingJson = true
			case .failure(let error):
				self.showErrorSnack(error: error.toTangemSdkError())
			}
		}))
	}
	
	private func isDataValid() -> Bool {
		return photo != nil &&
			!name.isEmpty &&
			!surname.isEmpty &&
			isSsnValid() &&
			selectedGender != .notSelected &&
			dateOfBirth != nil
	}
	
	private func isSsnValid() -> Bool {
		ssn.count == 11
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
