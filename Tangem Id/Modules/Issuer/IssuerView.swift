//
//  IssuerView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//

import SwiftUI

struct IssuerView: View, Equatable {
	static func == (lhs: IssuerView, rhs: IssuerView) -> Bool {
		print("Comparing issuer view")
		return lhs.viewModel == rhs.viewModel
	}
	
	@Environment(\.presentationMode) var presentationMode
	
	@ObservedObject var viewModel: IssuerViewModel
	
	@State var isCreatingCredentials: Bool = false
	
	var body: some View {
		return VStack {
			NavigationBar(
				title: LocalizationKeys.NavigationBar.issueCredentials,
				presentationMode: presentationMode
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
							text: LocalizationKeys.NavigationBar.issueCredentials,
							navigationLink: NavigationLink(
								"",
								destination: viewModel.createCredentialsLink,
								tag: true,
								selection: $viewModel.isCreatingCredentials),
							buttonStyle: ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					}
					.padding(.bottom, 40)
					.padding(.horizontal, 46)
				}
			}
		}
		.onAppear(perform: {
			print("Issuer view appeared")
		})
		.modifier(HiddenSystemNavigation())
		
	}
}

struct IssuerView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(IssuerView.self)!
			.deviceForPreview(.iPhone7)
	}
}
