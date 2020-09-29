//
//  IssuerCreateCredentialsView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import UIKit

struct IssuerCreateCredentialsView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@ObservedObject var viewModel: IssuerCreateCredentialsViewModel
	
	@State var name: String = ""
	@State var surname: String = ""
	
	@State var isOver18: Bool = false
	
	var body: some View {
		VStack {
			NavigationBar(
				title: "Issue Credentials",
				presentationMode: presentationMode
			)
			ScrollView {
				CredentialCard(
					title: "Photo") {
					ButtonWithImage(
						image: UIImage(named: "plus_blue")!,
						text: "Add photo",
						action: {},
						isLtr: true)
				} contentBuilder: {
					CredentialPhotoContent(image: .constant(UIImage(named: "dude")!))
				}
				CredentialCard(
					title: "Personal information",
					contentBuilder: {
						VStack {
							TextFieldWithClearButton(text: $name, placeholder: "Name")
							TextFieldWithClearButton(text: $surname, placeholder: "Surname")
							RadioSegmentSelector(
								segments: viewModel.availableGenders,
								selectedIndex: viewModel.selectedGenderIndex,
								selectionAction: viewModel.selectGender(at:)
							)
							VStack {
								HStack {
									Text("Date of Birth")
									Spacer()
									Image("calendar_gray")
								}
								Divider()
							}
							.padding()
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
							viewModel.inputSsn($0)
						}
						.font(.credentialCardContent)
						.frame(width: 130)
					})
				CredentialCard(
					title: "Age over 18",
					contentBuilder: {
						HStack {
							Text("Valid")
								.font(.credentialCardContent)
								.foregroundColor(Color.tangemBlack)
							Spacer()
								.background(Color.red)
							Checkbox(isSelected: $isOver18)
						}
						
						.padding(.horizontal)
						.padding(.bottom, 16)
						.background(Color.white)
						.onTapGesture(perform: {
							self.isOver18.toggle()
						})
					})
				Spacer()
					.frame(width: 10, height: 100)
			}
			.padding(.horizontal, 8)
		}
		
	}
}

struct IssuerCreateCredentialsView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(IssuerCreateCredentialsView.self)!
			.previewLayout(.fixed(width: 375, height: 1000))
	}
}
