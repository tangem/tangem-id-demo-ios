//
//  VerifierView.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct PersonalInformationLineView: View {
	
	var title: LocalizedStringKey
	var bodyText: String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(title)
				.foregroundColor(.placeholderTextColor)
				.font(.system(size: 14))
			Text(bodyText)
		}
		.padding(.bottom, 8)
	}
}

struct PersonalInformationView: View {
	var name: String
	var surname: String
	var dateOfBirth: String
	var gender: String
	
	var body: some View {
		VStack(alignment: .leading) {
			PersonalInformationLineView(title: LocalizationKeys.Common.name,
									bodyText: name)
			PersonalInformationLineView(title: LocalizationKeys.Common.surname,
									bodyText: surname)
			PersonalInformationLineView(title: LocalizationKeys.Common.dateOfBirth,
									bodyText: dateOfBirth)
			PersonalInformationLineView(title: LocalizationKeys.Common.gender,
									bodyText: gender)
			Divider()
		}
		.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
		.padding(.bottom, 8)
		.padding(.horizontal)
	}
}

struct CredentialCardValidCheckboxContent: View {
	
	var title: LocalizedStringKey
	var isCheckboxSelected: Bool
	
	var body: some View {
		VStack {
			HStack {
				Text(title)
				Spacer()
				Checkbox(isSelected: isCheckboxSelected)
					.disabled(true)
			}
			.padding(.bottom, 8)
			Divider()
		}
		.padding()
	}
}

struct VerifierView: View {
	
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel: VerifierViewModel
	
	@State private var isJsonPresentationShown: Bool = false
	
	var body: some View {
		VStack {
			NavigationBar(title: LocalizationKeys.NavigationBar.idValidator) {
				self.presentationMode.wrappedValue.dismiss()
			}
			ScrollView {
				viewModel.credentials.photo.map { photoCreds in
					CredentialCard(title: LocalizationKeys.Common.photo, contentBuilder: {
						CredentialPhotoContent(image: UIImage(data: photoCreds.credentials.photo) ?? UIImage())
					}, footerBuilder: {
						CredentialValidityFooter(status: photoCreds.status, issuerInfo: photoCreds.issuer)
					})
				}
				viewModel.credentials.personalInfo.map { personalInfoCreds in
					CredentialCard(title: LocalizationKeys.Common.personalInfo, contentBuilder: {
						PersonalInformationView(name: personalInfoCreds.credentials.name,
												surname: personalInfoCreds.credentials.surname,
												dateOfBirth: personalInfoCreds.credentials.dateOfBirth,
												gender: personalInfoCreds.credentials.gender)
					}, footerBuilder: {
						CredentialValidityFooter(status: personalInfoCreds.status, issuerInfo: personalInfoCreds.issuer)
					})
					.frame(minHeight: 420, maxHeight: .infinity)
				}
				viewModel.credentials.ssn.map { ssn in
					CredentialCard(title: LocalizationKeys.Common.ssn, supplementBuilder: {
						Text(ssn.credentials.ssn)
					}, contentBuilder: {
						Divider()
							.padding(.horizontal)
							.padding(.bottom, 8)
					}, footerBuilder: {
						CredentialValidityFooter(status: ssn.status, issuerInfo: ssn.issuer)
					})
				}
				viewModel.credentials.ageOver21.map { ageOver21 in
					CredentialCard(title: LocalizationKeys.Common.ageOver21, contentBuilder: {
						CredentialCardValidCheckboxContent(title: LocalizationKeys.Common.valid,
														   isCheckboxSelected: ageOver21.credentials.isOver21)
					}, footerBuilder: {
						CredentialValidityFooter(status: ageOver21.status, issuerInfo: ageOver21.issuer)
					})
				}
				viewModel.credentials.covid.map { covidCreds in
					CredentialCard(title: LocalizationKeys.Common.covidImmunity, contentBuilder: {
						CredentialCardValidCheckboxContent(title: LocalizationKeys.Common.valid,
														   isCheckboxSelected: covidCreds.credentials.isCovidPositive)
					}, footerBuilder: {
						CredentialValidityFooter(status: covidCreds.status, issuerInfo: covidCreds.issuer)
					})
				}
				Spacer()
					.frame(width: 10, height: 55)
				Button(LocalizationKeys.Common.showJsonCreds) {
					self.viewModel.loadJsonRepresentation()
				}
				.buttonStyle(ScreenPaddingButtonStyle.transparentBackWithBlueText)
				.sheet(isPresented: $isJsonPresentationShown, content: {
					JsonViewer(jsonMessage: self.viewModel.jsonRepresentation)
				})
				Spacer()
					.frame(width: 10, height: 18)
				Text("Current presentation of credentials can be stored.")
					.font(.system(size: 12))
				Spacer()
					.frame(width: 10, height: 40)
			}
			.padding(.horizontal, 10)
		}
		.modifier(HiddenSystemNavigation())
		.snack(data: $viewModel.snackMessage, show: $viewModel.isShowingSnack)
		.onReceive(viewModel.$jsonRepresentation, perform: { jsonRepresentation in
			if jsonRepresentation.isEmpty { return }
			self.isJsonPresentationShown = true
		})
	}
}

struct VerifierView_Previews: PreviewProvider {
    static var previews: some View {
		ApplicationAssembly.resolve(VerifierView.self)!
    }
}
