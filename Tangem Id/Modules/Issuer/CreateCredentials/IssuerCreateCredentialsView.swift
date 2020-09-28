//
//  IssuerCreateCredentialsView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import UIKit

struct TextFieldUI: UIViewRepresentable {
	@Binding var text: String
	
	var placeholder: String
	
	var keyType: UIKeyboardType
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		textField.keyboardType = keyType
		textField.clearButtonMode = .whileEditing
		let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
		let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
		toolBar.setItems(
			[.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton],
			animated: true
		)
		textField.inputAccessoryView = toolBar
		return textField
	}
	
	func updateUIView(_ uiView: UITextField, context: Context) {
		uiView.text = text
	}
}

extension UITextField {
	@objc func doneButtonTapped(button: UIBarButtonItem) -> Void {
	   self.resignFirstResponder()
	}
}

struct TextFieldWithClearButton: View {
	
	var text: Binding<String>
	let placeholder: String
	
	var body: some View {
		VStack {
			TextFieldUI(text: text, placeholder: placeholder, keyType: .default)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
			Divider()
		}
		.padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
	}
}

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
							VStack {
								TextField("Surname", text: $surname)
								Divider()
							}
							.padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
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
