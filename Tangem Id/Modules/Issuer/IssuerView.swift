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
		.padding()
	}
}

struct NavigationBar<LeftButtons: View, RightButtons: View>: View {
	
	private let title: String
	private let leftButtons: LeftButtons
	private let rightButtons: RightButtons
	private let titleFont: Font
	
	init(
		title: String,
		titleFont: Font = .credentialCardName,
		@ViewBuilder leftItems: () -> LeftButtons,
		@ViewBuilder rightItems: () -> RightButtons
	) {
		self.title = title
		self.titleFont = titleFont
		leftButtons = leftItems()
		rightButtons = rightItems()
	}
	
	var body: some View {
		ZStack {
			HStack {
				leftButtons
				Spacer()
				rightButtons
			}
			Text(title)
				.font(titleFont)
		}
		.frame(height: 44)
	}
}

struct IssuerView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@ObservedObject var viewModel: IssuerViewModel
	
	var body: some View {
		VStack {
			NavigationBar(
				title: "Issue Credentials",
				leftItems: {
					ArrowBack(action: {
						self.presentationMode.wrappedValue.dismiss()
					})
				},
				rightItems: {  }
			)
			.foregroundColor(.tangemBlack)
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
						NavigationButton(
							action: { self.viewModel.createNewCredentials() },
							text: "Issue credentials",
							navigationLink: NavigationLink(
								"",
								destination: viewModel.createCredentialsLink,
								isActive: $viewModel.isCreatingCredentials),
							buttonStyle: ScreenPaddingButtonStyle(height: 42, cornerRadius: 4, colorStyle: .blue, isDisabled: false))
					}
					.padding(.bottom, 40)
					.padding(.horizontal, 46)
				}
			}
		}
		.navigationBarHidden(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
		
	}
}

struct IssuerView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(IssuerView.self)!
			.deviceForPreview(.iPhone7)
	}
}
