//
//  IssuerView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//

import SwiftUI

struct ArrowBack: View {
	let action: () -> Void
	
	var body: some View {
		Button(action: action, label: {
			Image("arrow_left_black")
		})
	}
}

struct IssuerView: View {
	
	var body: some View {
		ZStack {
			VStack {
				Image("qr")
				Spacer()
					.frame(height: 48)
				Text("Ministry of Internal Affairs")
					.font(Font.system(size: 20, weight: .regular))
				Text("did:ethr:0x91901762C7d20d2894396c189d74483aFa118f4")
					.font(Font.system(size: 11, weight: .light))
					.foregroundColor(.gray)
					.padding(.leading, 66)
					.padding(.trailing, 55)
					.padding(.top, 6)
			}
			.offset(x: 0, y: -43)
			VStack {
				Spacer()
				ZStack {
					Button(action: {}, label: {
						Text("Issue credentials")
					})
					.buttonStyle(ScreenPaddingButtonStyle(height: 42, cornerRadius: 4, colorStyle: .blue, isDisabled: false))
				}
				.padding(.bottom, 40)
				.padding(.horizontal, 46)
			}
			
		}
		.navigationBarTitle(
			Text("Issue Credentials"),
			displayMode: .inline)
	}
}

struct IssuerView_Previews: PreviewProvider {
	static var previews: some View {
		IssuerView()
			.previewGroup()
	}
}
