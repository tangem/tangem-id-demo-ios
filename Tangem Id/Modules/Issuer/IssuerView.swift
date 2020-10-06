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
		VStack {
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
					Text(viewModel.issuerInfo.title)
						.font(Font.system(size: 20, weight: .regular))
					Text(viewModel.issuerInfo.didWalletAddress)
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
		.snack(data: $viewModel.snackMessage, show: $viewModel.isShowingSnack)
		.onAppear(perform: {
			print("Issuer view appeared")
		})
		.modifier(HiddenSystemNavigation())
		
	}
}

struct IssuerView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.assembler.resolver.resolve(IssuerView.self, argument: IssuerInfo(walletAddress: "did:ethr:someEtheriumAddress", name: "Some rangom affairs"))!
			.deviceForPreview(.iPhone7)
	}
}
