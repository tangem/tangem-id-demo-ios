//
//  CredentialCard.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct CredentialCard<Supplement: View, Content: View>: View {
	
	let title: String
	let supplementView: Supplement
	let content: Content
	
	init(
		title: String,
		@ViewBuilder supplementBuilder: () -> Supplement,
		@ViewBuilder contentBuilder: () -> Content
	) {
		self.title = title
		supplementView = supplementBuilder()
		content = contentBuilder()
	}
	
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
					CredentialPhotoContent(image: .constant(UIImage(named: "dude")!))
				})
				.previewLayout(.fixed(width: 375, height: 260))
			CredentialCard(
				title: "SSN",
				supplementBuilder: {
					TextField("000 - 00 - 0000", text: .constant(""))
						.font(.credentialCardContent)
						.frame(width: 125)
				}, contentBuilder: {
					
				})
				.previewLayout(.fixed(width: 375, height: 320))
		}
	}
}
