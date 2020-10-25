//
//  HolderView.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct HolderView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel: HolderViewModel
	
	@State var isDisplayingPopup: Bool = false
	@State var popupTitle: LocalizedStringKey = ""
	@State var isShowingPhotoCreds: Bool = false
	@State var isShowingPersonalInfo: Bool = false
	@State var isShowingSsnCreds: Bool = false
	@State var isShowingAgeOver21Creds: Bool = false
	@State var isShowingCovidCreds: Bool = false
	
	var body: some View {
		ZStack {
			VStack {
				Image("holder_back")
					.resizable()
					.edgesIgnoringSafeArea(.top)
					.frame(maxHeight: 280)
				Spacer()
			}
			VStack {
				NavigationBar(title: LocalizationKeys.Modules.Holder.personalCard, titleColor: .white,
							  leftItems: {
								ArrowBack(action: {
									self.presentationMode.wrappedValue.dismiss()
								}, color: .white)
							  }, rightItems: {
								
							})
				ScrollView {
					VStack {
						Spacer()
						HStack {
							Spacer()
							Image("tangem_logo")
						}
						.padding()
					}
					.background(Color.white)
					.cornerRadius(10)
					.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 3)
					.frame(width: 272, height: 172, alignment: .center)
					.padding(.top, 28)
					.padding(.bottom, 12)
					Text(viewModel.holderCredentials.cardId)
						.bold()
						.foregroundColor(.tangemDarkGray)
					Spacer()
						.frame(width: 10, height: 20)
					VStack {
						HStack {
							Text(LocalizationKeys.Modules.Holder.credentials)
								.bold()
							Spacer()
							Button(action: {
								withAnimation {
									self.viewModel.isEditing.toggle()
								}
							}, label: {
								Image(systemName:
										viewModel.isEditing ?
										"xmark" :
										"pencil")
									.resizable()
									.frame(width: 18, height: 18)
									.foregroundColor(.tangemBlack)
							})
							.padding(18)
						}
						Group {
							if let photoCreds = viewModel.holderCredentials.photo {
								HolderCredentialLine(
									name: LocalizationKeys.Common.photo,
									isPrivate: photoCreds.file.fileSettings == .private,
									isEditing: viewModel.isEditing,
									deleteAction: {
										self.viewModel.deleteCreds(.photo)
									},
									togglePrivacyAction: {
										self.viewModel.toggleCredsVisibility(.photo)
									}
								)
								.background(Color.white.opacity(0.01))
								.onTapGesture(perform: {
									if self.viewModel.isEditing { return }
									self.isDisplayingPopup = true
								})
								.sheet(isPresented: $isDisplayingPopup, content: {
									HolderCredentialViewer<PhotoCredential>(credential: photoCreds)
								})
							}
							if let personalInfo = viewModel.holderCredentials.personalInfo {
								HolderCredentialLine(
									name: LocalizationKeys.Common.personalInfo,
									isPrivate: personalInfo.file.fileSettings == .private,
									isEditing: viewModel.isEditing,
									deleteAction: {
										self.viewModel.deleteCreds(.info)
									},
									togglePrivacyAction: {
										self.viewModel.toggleCredsVisibility(.info)
									}
								)
								.background(Color.white.opacity(0.01))
								.onTapGesture(perform: {
									if self.viewModel.isEditing { return }
									self.isShowingPersonalInfo = true
								})
								.sheet(isPresented: $isShowingPersonalInfo, content: {
									HolderCredentialViewer<PersonalInfoCredential>(credential: personalInfo)
								})
							}
							if let ssn = viewModel.holderCredentials.ssn {
								HolderCredentialLine(
									name: LocalizationKeys.Common.ssn,
									isPrivate: ssn.file.fileSettings == .private,
									isEditing: viewModel.isEditing,
									deleteAction: {
										self.viewModel.deleteCreds(.ssn)
									},
									togglePrivacyAction: {
										self.viewModel.toggleCredsVisibility(.ssn)
									}
								)
								.background(Color.white.opacity(0.01))
								.onTapGesture(perform: {
									if self.viewModel.isEditing { return }
									self.isShowingSsnCreds = true
								})
								.sheet(isPresented: $isShowingSsnCreds, content: {
									HolderCredentialViewer<SsnCredential>(credential: ssn)
								})
							}
							if let ageOver21 = viewModel.holderCredentials.ageOver21 {
								HolderCredentialLine(
									name: LocalizationKeys.Common.ageOver21,
									isPrivate: ageOver21.file.fileSettings == .private,
									isEditing: viewModel.isEditing,
									deleteAction: {
										self.viewModel.deleteCreds(.ageOver21)
									},
									togglePrivacyAction: {
										self.viewModel.toggleCredsVisibility(.ageOver21)
									}
								)
								.background(Color.white.opacity(0.01))
								.onTapGesture(perform: {
									if self.viewModel.isEditing { return }
									self.isShowingAgeOver21Creds = true
								})
								.sheet(isPresented: $isShowingAgeOver21Creds, content: {
									HolderCredentialViewer<AgeOver21Credential>(credential: ageOver21)
								})
							}
							if let covidCreds = viewModel.holderCredentials.covid {
								HolderCredentialLine(
									name: LocalizationKeys.Common.covidImmunity,
									isPrivate: covidCreds.file.fileSettings == .private,
									isEditing: viewModel.isEditing,
									deleteAction: {
										self.viewModel.deleteCreds(.covid)
									},
									togglePrivacyAction: {
										self.viewModel.toggleCredsVisibility(.covid)
									}
								)
								.background(Color.white.opacity(0.01))
								.onTapGesture(perform: {
									if self.viewModel.isEditing { return }
									self.isShowingCovidCreds = true
								})
								.sheet(isPresented: $isShowingCovidCreds, content: {
									HolderCredentialViewer<CovidCredential>(credential: covidCreds)
								})
							}
						}
						.foregroundColor(.tangemDarkGray)
					}
					.padding(.leading)
					.frame(minWidth: 0, maxWidth: .infinity)
					Spacer()
						.frame(width: 10, height: 44)
					Button(viewModel.isEditing ?
							LocalizationKeys.Modules.Holder.saveChanges :
							LocalizationKeys.Modules.Holder.requestNewCreds) {
						if self.viewModel.isEditing {
							self.viewModel.saveChanges()
						} else {
							self.viewModel.requestNewCreds()
						}
					}
					.transition(.opacity)
					.buttonStyle(ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					.padding(.horizontal, 46)
					Spacer()
						.frame(width: 10, height: 44)
				}
			}
		}
		.snack(data: $viewModel.snackMessage, show: $viewModel.isShowingSnack)
		.modifier(HiddenSystemNavigation())
	}
}

struct HolderView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(HolderView.self)!
	}
}
