//
//  HolderViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk

enum AvailableCredsType {
	case photo, info, ssn, ageOver21, covid
}

final class HolderViewModel: ObservableObject, SnackMessageDisplayable {
	
	private let holderManager: TangemHolderManager
	
	@Published private(set) var holderCredentials: HolderViewCredentials
	@Published var isEditing: Bool = false {
		didSet {
			if isEditing {
				originalCredentials = holderCredentials.copy() as? HolderViewCredentials
				credsToDelete.removeAll()
				credsToUpdateVisibility.removeAll()
				return
			}
			if let creds = originalCredentials {
				credsToUpdateVisibility.forEach {
					$0.value.fileSettings?.toggleVisibility()
				}
				holderCredentials = creds
				originalCredentials = nil
			}
		}
	}
	@Published var snackMessage: SnackData = .emptySnack
	@Published var isShowingSnack: Bool = false
	
	var scannedQrCode: String = ""
	
	private var originalCredentials: HolderViewCredentials?
	private var credsToDelete: [File] = []
	private var credsToUpdateVisibility: [Int: File] = [:]
	
	init(holderManager: TangemHolderManager, holderCredentials: HolderViewCredentials) {
		self.holderManager = holderManager
		self.holderCredentials = holderCredentials
	}
	
	func deleteCreds(_ type: AvailableCredsType) {
		let file: File
		switch type {
		case .photo:
			guard let photo = holderCredentials.photo else { return }
			file = photo.file
			holderCredentials.photo = nil
		case .info:
			guard let info = holderCredentials.personalInfo else { return }
			file = info.file
			holderCredentials.personalInfo = nil
		case .ssn:
			guard let ssn = holderCredentials.ssn else { return }
			file = ssn.file
			holderCredentials.ssn = nil
		case .ageOver21:
			guard let age = holderCredentials.ageOver21 else { return }
			file = age.file
			holderCredentials.ageOver21 = nil
		case .covid:
			guard let covid = holderCredentials.covid else { return }
			file = covid.file
			holderCredentials.covid = nil
		}
		let fileIndex = file.fileIndex
		credsToUpdateVisibility.removeValue(forKey: fileIndex)
		credsToDelete.append(file)
		objectWillChange.send()
	}
	
	func toggleCredsVisibility(_ type: AvailableCredsType) {
		let file: File
		switch type {
		case .photo:
			guard let photo = holderCredentials.photo else { return }
			file = photo.file
		case .info:
			guard let info = holderCredentials.personalInfo else { return }
			file = info.file
		case .ssn:
			guard let ssn = holderCredentials.ssn else { return }
			file = ssn.file
		case .ageOver21:
			guard let age = holderCredentials.ageOver21 else { return }
			file = age.file
		case .covid:
			guard let covid = holderCredentials.covid else { return }
			file = covid.file
		}
		file.fileSettings?.toggleVisibility()
		objectWillChange.send()
		let fileIndex = file.fileIndex
		if credsToUpdateVisibility[fileIndex] == nil {
			credsToUpdateVisibility[fileIndex] = file
		} else {
			credsToUpdateVisibility.removeValue(forKey: fileIndex)
		}
	}
	
	func saveChanges() {
		holderManager.execute(action: .saveChanges(filesToDelete: credsToDelete, filesToUpdateSettings: credsToUpdateVisibility.map { $0.value }, completion: { [weak self] (result) in
			switch result {
			case .success:
				self?.originalCredentials = nil
				self?.isEditing = false
				self?.credsToDelete.removeAll()
				self?.credsToUpdateVisibility.removeAll()
				self?.objectWillChange.send()
			case .failure(let error):
				self?.showErrorSnack(error: error)
			}
		}))
	}
	
	func qrCodeScanned(_ qr: String) {
		guard holderCredentials.covid == nil else {
			showInfoSnack(message: LocalizedStrings.Snacks.alreadyHasCredential)
			return
		}
		holderManager.execute(action: .requestCovidCreds(completion: { [weak self] (result) in
			switch result {
			case .success(let covidCreds):
				self?.holderCredentials.covid = covidCreds
				self?.objectWillChange.send()
				break
			case .failure(let error):
				self?.showErrorSnack(error: error)
			}
		}))
	}
	
	func changePasscode() {
		holderManager.execute(action: .changePasscode(completion: { [weak self] (result) in
			switch result {
			case .success(let response):
				print(response)
				self?.showInfoSnack(message: LocalizedStrings.Snacks.passcodeChanged)
			case .failure(let error):
				self?.showErrorSnack(error: error)
			}
		}))
	}
	
}
