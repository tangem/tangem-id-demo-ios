//
//  RoleSelectorView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/25/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}

	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}

struct RoleSelectorView: View, Equatable {
	static func == (lhs: RoleSelectorView, rhs: RoleSelectorView) -> Bool {
		print("Comparing role selector views")
		return lhs.viewModel == rhs.viewModel
	}
	
	@ObservedObject var viewModel: RoleSelectorViewModel
	@State private var isActive : Bool = false 
	
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
				(Text(LocalizationKeys.Modules.RoleSelector.descriptionText) +
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
						action: { self.viewModel.issuerButtonAction() },
						text: LocalizationKeys.Common.iIssuer,
						navigationLink:
							NavigationLink("",
										   destination: viewModel.issuerLink,
										   isActive: $viewModel.isIssuer),
						buttonStyle: ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					NavigationButton(
						action: { self.viewModel.verifierButtonAction() },
						text: LocalizationKeys.Common.iVerifier,
						navigationLink: NavigationLink(
							"",
							destination: viewModel.verifierLink,
							isActive: $viewModel.isVerifier),
						buttonStyle: ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					NavigationButton(
						action: { self.viewModel.holderButtonAction() },
						text: LocalizationKeys.Common.iHolder,
						navigationLink: NavigationLink(
							"",
							destination: viewModel.holderLink,
							isActive: $viewModel.isHolder),
						buttonStyle: ScreenPaddingButtonStyle.defaultWhiteButtonStyleWithPadding)
				}
				.padding(.horizontal, 46)
				.padding(.bottom, 40)
			}
			.modifier(HiddenSystemNavigation())
		}
		.snack(data: $viewModel.snackMessage, show: $viewModel.isShowingSnack)
		.navigationViewStyle(StackNavigationViewStyle())
		.environment(\.rootPresentationMode, $viewModel.isIssuer)
	}
}

struct RoleSelector_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationAssembly.resolve(RoleSelectorView.self)!
			.deviceForPreview(.iPhone7)
	}
}
