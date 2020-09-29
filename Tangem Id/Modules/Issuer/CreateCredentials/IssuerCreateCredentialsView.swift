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
	
	@State var ssn: String = ""
	
	@State var name: String = ""
	@State var surname: String = ""
	
	@State var isOver18: Bool = false
	
    var body: some View {
		VStack {
			NavigationBar(
				title: "Issue Credentials",
				leftItems: {
					ArrowBack(action: {
						self.presentationMode.wrappedValue.dismiss()
					})
				}, rightItems: { })
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
					supplementBuilder: {},
					contentBuilder: {
						VStack {
							TextFieldWithClearButton(text: $name, placeholder: "Name")
							TextFieldWithClearButton(text: $surname, placeholder: "Surname")
						}
					})
				CredentialCard(
					title: "SSN",
					supplementBuilder: {
						TextField(
							"000 - 00 - 0000",
							text: $ssn,
							onEditingChanged: { changed in
								
							}) {
							
						}
						.keyboardType(.numberPad)
						.font(.credentialCardContent)
						.frame(width: 125)
					}, contentBuilder: {
						
					})
				CredentialCard(
					title: "Age over 18",
					supplementBuilder: {
						
					}, contentBuilder: {
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
					.frame(width: 10, height: 150)
			}
			.padding(.horizontal, 8)
		}
		
    }
}

struct IssuerCreateCredentialsView_Previews: PreviewProvider {
    static var previews: some View {
		ApplicationAssembly.resolve(IssuerCreateCredentialsView.self)!
			.deviceForPreview(.iPhone7)
    }
}
