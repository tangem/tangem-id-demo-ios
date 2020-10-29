//
//  HolderCredentialViewer.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/23/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import TangemSdk

struct HolderCredentialViewer<Creds: DemoCredential>: View {
	
	var credential: HolderCredential<Creds>
	
	@Environment(\.presentationMode) var presentationMode
	@State var isShowingJson: Bool = false
	@State var isSharePresented: Bool = false
	
	func content() -> some View {
		var title: LocalizedStringKey = ""
		var content: AnyView = AnyView(EmptyView())
		var supplement: AnyView = AnyView(EmptyView())
		if let photo = credential.credentials as? PhotoCredential, let image = UIImage(data: photo.photo) {
			title = LocalizationKeys.Common.photo
			content = AnyView(
				VStack {
					CredentialPhotoContent(image: image, isSquare: true)
						.frame(maxWidth: .infinity, maxHeight: 200)
				})
		}
		if let personalInfo = credential.credentials as? PersonalInfoCredential {
			title = LocalizationKeys.Common.personalInfo
			content = AnyView(
				PersonalInformationView(name: personalInfo.name,
										surname: personalInfo.surname,
										dateOfBirth: personalInfo.dateOfBirth,
										gender: personalInfo.gender)
			)
		}
		if let ssn = credential.credentials as? SsnCredential {
			title = LocalizationKeys.Common.ssn
			content = AnyView(
				Divider()
					.padding(.horizontal)
			)
			supplement = AnyView(
				Text(ssn.ssn)
					.foregroundColor(.tangemBlack)
					.padding()
			)
		}
		if let ageOver21 = credential.credentials as? AgeOver21Credential {
			title = LocalizationKeys.Common.ageOver21
			content = AnyView(
				CredentialCardValidCheckboxContent(title: LocalizationKeys.Common.valid, isCheckboxSelected: ageOver21.isOver21, animated: false)
			)
		}
		if let covidCreds = credential.credentials as? CovidCredential {
			title = LocalizationKeys.Common.covidImmunity
			content = AnyView(
				CredentialCardValidCheckboxContent(title: LocalizationKeys.Common.valid, isCheckboxSelected: covidCreds.isCovidPositive)
			)
		}
		return
			VStack {
				HStack {
					Text(title)
						.bold()
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
					Spacer()
					supplement
				}
				ScrollView {
					content
					if !credential.json.isEmpty && self.isShowingJson {
						VStack {
							Text(LocalizationKeys.Modules.Holder.jsonRepresentation)
								.bold()
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(credential.json)
								.padding(.top, 16)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						.padding(.horizontal)
						.opacity(isShowingJson ? 1.0 : 0.0)
						.animation(.easeInOut)
					}
				}
		}
	}
	
	var body: some View {
		VStack {
			content()
				.foregroundColor(.tangemBlack)
			HStack {
				Spacer()
				Button(LocalizationKeys.Common.hide) {
					self.presentationMode.wrappedValue.dismiss()
				}
				.padding(.horizontal, 10)
				.foregroundColor(.tangemBlue)
				if !credential.json.isEmpty {
					Button(!isShowingJson ? LocalizationKeys.Common.showJsonCreds : LocalizationKeys.Modules.Holder.shareJson) {
						if !self.isShowingJson {
							withAnimation {
								self.isShowingJson = true
							}
						} else {
							self.isSharePresented = true
						}
					}
					.foregroundColor(.tangemBlue)
					.sheet(isPresented: $isSharePresented, content: {
						ShareView(itemsToShare: [self.credential.json] as [Any], applicationActivities: nil)
					})
				}
			}
			.padding()
		}
	}
}

struct HolderCredentialViewer_Previews: PreviewProvider {
	static var previews: some View {
		HolderCredentialViewer(
			credential: HolderCredential<PhotoCredential>(credentials: PhotoCredential(photo: Data(base64Encoded: "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") ?? Data()),
														  file: File(fileIndex: 0, fileSettings: .public, fileData: Data()),
														  json: """
			{
						"credentialSubject": {
				 "id": "did:ethr:0x7a1B9E95689edF8576c14Abb30B96BBE4d22dECC",
				 "givenName": "Андер",
				 "familyName": "Сон",
				 "gender": "Male",
				 "born": "12/28/1990",
				 "photoHash": "Q0YeuLt1ApzRezJOX4KHKExYYt5pqOJj_pd36dBv0Is=\n"
			   },
			   "issuer": "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe",
			   "issuanceDate": "2020-10-21T07:47:30.911Z",
			   "ethCredentialStatus": "0x01fB6133d6Bc292eA64B3D1787Dc0AB887EE45b8",
			   "@context": [
				 "https://www.w3.org/2018/credentials/v1"
			   ],
			   "type": [
				 "VerifiableCredential",
				 "TangemEthCredential",
				 "TangemPersonalInformationCredential"
			   ],
			   "proof": {
				 "verificationMethod": "did:ethr:0x3ce9295d79dD943c8BE6Ee4FF15B9b71920E99fe#owner",
						"jws": "eyJhbGciOiJFUzI1NksiLCJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdfQ==\n..PTRC68LfL1CzR521iORnYQShsmVTh6Yhhx53Xao4ZK4lCHGh1vOH_Dy4cu8L4iDrI0_PhLbpq2Qp\noy1VxmhXNg==\n"
			 }
			}
			"""
			)
		)
	}
}
