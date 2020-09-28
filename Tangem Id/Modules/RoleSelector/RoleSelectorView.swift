//
//  RoleSelectorView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/25/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct RoleSelectorView: View {
	@ObservedObject var viewModel: RoleSelectorViewModel
	
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
					.frame(minWidth: 10, minHeight: 45, idealHeight: 46, maxHeight: 126)
				Image("logo_main")
					.padding(.bottom, 16)
				Text("Tangem ID")
					.font(Font.system(size: 28, weight: .light))
				Spacer()
					.frame(width: 100, height: 56)
				(Text("This application demonstrates the Tangem ID solution. Conformant with W3C DID and Verifiable Credential. Try for yourself! Get ID cards kit at ") +
					Text("shop.tangem.com")
					.foregroundColor(.tangemBlue)
				)
					.onTapGesture(perform: {
						self.viewModel.openShop()
					})
					.multilineTextAlignment(.center)
					.font(Font.system(size: 13, weight: .regular, design: .default))
					.lineSpacing(7)
					.padding(.horizontal, 46)
					.layoutPriority(1)
				Spacer()
					.frame(minHeight: 96)
				VStack(spacing: 16) {
					NavigationButton(
						action: { viewModel.issuerButtonAction() },
						contentView: Text("Issuer"),
						navigationLink: NavigationLink(
							"",
							destination: viewModel.issuerLink,
							tag: RoleSelectorViewModel.ViewState.issuer,
							selection: $viewModel.state
						),
						buttonStyle: ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding
					)
					NavigationButton(
						action: { viewModel.verifierButtonAction() },
						text: "Verifier",
						navigationLink: NavigationLink(
							"",
							destination: viewModel.veridierLink,
							tag: RoleSelectorViewModel.ViewState.verifier,
							selection: $viewModel.state),
						buttonStyle: ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					NavigationButton(
						action: { viewModel.holderButtonAction() },
						text: "Holder",
						navigationLink: NavigationLink(
							destination: viewModel.holderLink,
							tag: RoleSelectorViewModel.ViewState.holder,
							selection: $viewModel.state,
							label: { EmptyView() }),
						buttonStyle: ScreenPaddingButtonStyle.defaultWhiteButtonStyleWithPadding)
				}
				.padding(.horizontal, 46)
				.padding(.bottom, 40)
			}
			.navigationBarTitle(Text(" "), displayMode: .inline)
			.background(NavigationController() { navi in
				let bar = navi.navigationBar
				bar.titleTextAttributes = [
					.font: UIFont.systemFont(ofSize: 20, weight: .bold),
					.foregroundColor: UIColor.tangemBlack
				]
				bar.backgroundColor = .clear
				bar.setBackgroundImage(UIColor.clear.image(), for: .default)
				bar.shadowImage = UIColor.clear.image()
			})
		}
	}
}

struct RoleSelector_Previews: PreviewProvider {
	static let resolver = ApplicationAssembly.assembler.resolver
	static var previews: some View {
		resolver
			.resolve(RoleSelectorView.self)!
			.previewGroup()
	}
}
