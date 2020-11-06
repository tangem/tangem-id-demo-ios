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
	@Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
	
	@ObservedObject var viewModel: IssuerCreateCredentialsViewModel
	@ObservedObject var keyboardHandler: KeyboardFollower = KeyboardFollower()
	
	@State private var showingImagePicker = false
	@State private var showingJsonRepresentation = false
	@State private var isShowingSnack = false
	@State private var isShowingBackAlert = false
	
	func photoCard() -> some View {
		let title = LocalizationKeys.Modules.Issuer.photo
		let addPhotoButton = ButtonWithImage(image: UIImage(systemName: "plus")!,
											 color: .tangemBlue,
											 text: LocalizationKeys.Common.addPhoto,
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
			NavigationBar(title: LocalizationKeys.NavigationBar.issueCredentials) {
				if self.viewModel.isCredentialsCreated {
					self.isShowingBackAlert = true
				} else {
					self.presentationMode.wrappedValue.dismiss()
				}
			}
			.alert(isPresented: $isShowingBackAlert, content: {
				Alert(title: Text(LocalizationKeys.Modules.Issuer.credentialsSignedWarningTitle),
					  message: Text(LocalizationKeys.Modules.Issuer.credentialsSignedWarningBody),
					  primaryButton: .destructive(Text(LocalizationKeys.Common.dismiss), action: {
						self.isShowingBackAlert = false
						self.presentationMode.wrappedValue.dismiss()
					  }),
					  secondaryButton: .default(Text(LocalizationKeys.Common.stay)))
			})
			ScrollView {
				VStack {
					photoCard()
						.sheet(isPresented: $showingImagePicker, onDismiss: { print("Image picked") }, content: {
							ImagePicker(image: self.$viewModel.photo)
						})
					CredentialCard(
						title: LocalizationKeys.Modules.Issuer.personalInfo,
						contentBuilder: {
							VStack {
								TextFieldWithClearButton(placeholder: LocalizedStrings.Common.name) { self.viewModel.inputName($0) }
								TextFieldWithClearButton(placeholder: LocalizedStrings.Common.surname) { self.viewModel.inputSurname($0) }
								RadioSegmentSelector(
									segments: viewModel.availableGenders,
									selectedIndex: viewModel.selectedGenderIndex,
									selectionAction: viewModel.selectGender(at:)
								)
								DatePicker(placeholder: LocalizedStrings.Common.dateOfBirth.localizedString(), date: $viewModel.dateOfBirth)
							}
					})
						.frame(height: 300)
					CredentialCard(
						title: LocalizationKeys.Common.ssn,
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
						title: LocalizationKeys.Common.ageOver21,
						contentBuilder: {
							ClickableRowWithCheckbox(
								isSelected: viewModel.isOver21,
								action: {
							})
					})
				}
				.disabled(viewModel.isCredentialsCreated)
				.opacity(viewModel.isCredentialsCreated ? 0.6 : 1.0)
				Group {
					Spacer()
						.frame(width: 10, height: 45, alignment: .center)
					Button(viewModel.isCredentialsCreated ?
							LocalizationKeys.Modules.Issuer.writeToCardCredentials :
							LocalizationKeys.Modules.Issuer.signCredentials) {
						if self.viewModel.isCredentialsCreated {
							self.viewModel.writeCredentialsToCard()
						} else {
							self.viewModel.signEnteredInfo()
						}
					}
					.buttonStyle(ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					if viewModel.isCredentialsCreated {
						Spacer()
							.frame(width: 10, height: 18, alignment: .center)
						Button(LocalizationKeys.Common.showJsonCreds) {
							viewModel.showJsonRepresentation()
						}
						.buttonStyle(ScreenPaddingButtonStyle.transparentBackWithBlueText)
						.sheet(isPresented: $showingJsonRepresentation, content: {
							JsonViewer(jsonMessage: viewModel.jsonRepresentation)
						})
					}
					Spacer()
						.frame(width: 10, height: 100)
				}
				.padding(.horizontal, 46)
			}
			.padding(.horizontal, 8)
		}
		.padding(.bottom, keyboardHandler.keyboardHeight)
		.snack(data: $viewModel.snackMessage, show: $viewModel.isShowingSnack)
		.onAppear(perform: {
			if #available(iOS 14, *) { return }
			self.keyboardHandler.subscribe()
		})
		.onDisappear(perform: {
			if #available(iOS 14, *) { return }
			self.keyboardHandler.unsubscribe()
		})
		.modifier(HiddenSystemNavigation())
		.onReceive(viewModel.$shouldDismissToRoot) { shouldDismiss in
			guard shouldDismiss else { return }
			rootPresentationMode.wrappedValue.dismiss()
		}
		.onReceive(viewModel.$jsonRepresentation) { jsonRepresenation in
			if jsonRepresenation.isEmpty { return }
			showingJsonRepresentation = true
		}
	}
}

struct IssuerCreateCredentialsView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(IssuerCreateCredentialsView.self)!
			.deviceForPreview(.iPhone7)
	}
}
