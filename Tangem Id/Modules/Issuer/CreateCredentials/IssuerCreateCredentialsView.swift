//
//  IssuerCreateCredentialsView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import UIKit

struct IssuerCreateCredentialsView: View, Equatable {
	
	static func == (lhs: IssuerCreateCredentialsView, rhs: IssuerCreateCredentialsView) -> Bool {
		print("Comparing creating credentials view")
		return lhs.viewModel == rhs.viewModel
	}
	
	@Environment(\.presentationMode) var presentationMode
	
	@ObservedObject var viewModel: IssuerCreateCredentialsViewModel
	@ObservedObject var keyboardHandler: KeyboardFollower = KeyboardFollower()
	
	@State private var showingImagePicker = false
	
	func photoCard() -> some View {
		let title = "Photo"
		let addPhotoButton = ButtonWithImage(image: UIImage(systemName: "plus")!,
											 color: .tangemBlue,
											 text: "Add photo",
											 action: { self.showingImagePicker = true },
											 isLtr: true)
		if let photo = viewModel.photo {
			return AnyView(CredentialCard(
				title: title,
				supplementBuilder: {
					addPhotoButton
			}, contentBuilder: {
				CredentialPhotoContent(image: photo)
			}))
		} else {
			return AnyView(CredentialCard(title: title,
										  supplementBuilder: {
											addPhotoButton
			}))
		}
	}
	
	var body: some View {
		VStack {
			NavigationBar(title: "Issue Credentials", presentationMode: presentationMode)
				.foregroundColor(.tangemBlack)
			ScrollView {
				photoCard()
				CredentialCard(
					title: "Personal information",
					contentBuilder: {
						VStack {
							TextFieldWithClearButton(placeholder: "Name") { (newText) in
								self.viewModel.inputName(newText)
							}
							TextFieldWithClearButton(placeholder: "Surname") {
								self.viewModel.inputSurname($0)
							}
							RadioSegmentSelector(
								segments: viewModel.availableGenders,
								selectedIndex: viewModel.selectedGenderIndex,
								selectionAction: viewModel.selectGender(at:)
							)
							DatePicker(placeholder: "Date of birth", date: $viewModel.dateOfBirth)
						}
				})
					.frame(height: 300)
				CredentialCard(
					title: "SSN",
					supplementBuilder: {
						MaskedTextField(
							placeholder: "000 - 00 - 0000",
							isWithClearButton: false,
							keyType: .numberPad) {
								self.viewModel.inputSsn($0)
						}
						.font(.credentialCardContent)
						.frame(width: 130)
				})
				CredentialCard(
					title: "Age over 18",
					contentBuilder: {
						ClickableRowWithCheckbox(
							isSelected: viewModel.isOver18,
							action: {
								self.viewModel.isOver18Action()
						})
				})
				Spacer()
					.frame(width: 10, height: 100)
			}
			.padding(.horizontal, 8)
		}
		.padding(.bottom, keyboardHandler.keyboardHeight)
		.sheet(isPresented: $showingImagePicker, onDismiss: { print("Image picked") }, content: {
			ImagePicker(image: self.$viewModel.photo)
		})
			.onAppear(perform: {
				self.keyboardHandler.subscribe()
			})
			.onDisappear(perform: {
				self.keyboardHandler.unsubscribe()
			})
			.modifier(HiddenSystemNavigation())
	}
}

struct IssuerCreateCredentialsView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(IssuerCreateCredentialsView.self)!
			.deviceForPreview(.iPhone7)
	}
}
