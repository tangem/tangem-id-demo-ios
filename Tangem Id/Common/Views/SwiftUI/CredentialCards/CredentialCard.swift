//
//  CredentialCard.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct CredentialCard<Supplement: View, Content: View, Footer: View>: View {
	
	let title: LocalizedStringKey
	let supplementView: Supplement
	let content: Content
	let footer: Footer
	
	init(
		title: LocalizedStringKey,
		@ViewBuilder supplementBuilder: () -> Supplement,
		@ViewBuilder contentBuilder: () -> Content,
		@ViewBuilder footerBuilder: () -> Footer
	) {
		self.title = title
		supplementView = supplementBuilder()
		content = contentBuilder()
		footer = footerBuilder()
	}
	
	@ViewBuilder
    var body: some View {
		VStack {
			HStack {
				Text(title)
					.font(.credentialCardName)
					.foregroundColor(.tangemBlack)
				Spacer()
				supplementView
				
			}
			.padding(16)
			content
			footer
		}
		.background(Color.white)
		.cornerRadius(4)
		.shadow(color: Color.black.opacity(0.4),
				radius: 2,
				x: 0,
				y: 2)
		.padding(.all, 8)
    }
}

extension CredentialCard where Footer == EmptyView {
	init(title: LocalizedStringKey, @ViewBuilder supplementBuilder: () -> Supplement, @ViewBuilder contentBuilder: () -> Content) {
		self.title = title
		self.supplementView = supplementBuilder()
		self.content = contentBuilder()
		footer = EmptyView()
	}
}

extension CredentialCard where Supplement == EmptyView {
	init(title: LocalizedStringKey, @ViewBuilder contentBuilder: () -> Content,  @ViewBuilder footerBuilder: () -> Footer) {
		self.title = title
		self.supplementView = EmptyView()
		self.content = contentBuilder()
		self.footer = footerBuilder()
	}
}

extension CredentialCard where Content == EmptyView {
	init(title: LocalizedStringKey, @ViewBuilder supplementBuilder: () -> Supplement,  @ViewBuilder footerBuilder: () -> Footer) {
		self.title = title
		self.supplementView = supplementBuilder()
		self.content = EmptyView()
		self.footer = footerBuilder()
	}
}

extension CredentialCard where Content == EmptyView, Footer == EmptyView {
	init(title: LocalizedStringKey, @ViewBuilder supplementBuilder: () -> Supplement) {
		self.title = title
		supplementView = supplementBuilder()
		content = EmptyView()
		footer = EmptyView()
	}
}

extension CredentialCard where Supplement == EmptyView, Footer == EmptyView {
	init (title: LocalizedStringKey, @ViewBuilder contentBuilder: () -> Content) {
		self.title = title
		supplementView = EmptyView()
		content = contentBuilder()
		footer = EmptyView()
	}
}

struct CredentialCard_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			CredentialCard(
				title: "Photo",
				supplementBuilder: {
					Button(action: {}, label: {
						HStack(spacing: 12) {
							Image("plus_blue")
							Text("Add Photo")
								.foregroundColor(.tangemBlue)
						}
					})
				},
				contentBuilder: {
					CredentialPhotoContent(image: UIImage(named: "dude")!)
				},
				footerBuilder: {
					CredentialValidityFooter(status: .invalid)
				})
				.previewLayout(.fixed(width: 375, height: 400))
			CredentialCard(title: LocalizationKeys.Common.personalInfo, contentBuilder: {
				VStack(alignment: .leading) {
					PersonalInformationView(title: LocalizationKeys.Common.name,
											bodyText: "Tangem")
					PersonalInformationView(title: LocalizationKeys.Common.surname,
											bodyText: "Holder")
					PersonalInformationView(title: LocalizationKeys.Common.dateOfBirth,
											bodyText: "10/4/2020")
					PersonalInformationView(title: LocalizationKeys.Common.gender,
											bodyText: "Other")
				}
				.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
				.padding(.bottom, 8)
				.padding(.horizontal)
			}, footerBuilder: {
				CredentialValidityFooter(status: .valid, issuerInfo: .init(address: "someaddressveryveryverylongaddress", isTrusted: false))
			})
			.previewLayout(.fixed(width: 375, height: 400))
			CredentialCard(
				title: "SSN",
				supplementBuilder: {
					TextField("000 - 00 - 0000", text: .constant(""))
					.font(.credentialCardContent)
					.frame(width: 125)
			})
				.previewLayout(.fixed(width: 375, height: 320))
		}
	}
}
