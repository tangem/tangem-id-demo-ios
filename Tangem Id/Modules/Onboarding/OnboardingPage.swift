//
//  ContentView.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/25/20.
//

import SwiftUI

struct OnboardingPage: View {
	
	@State var isIssuer = false
	
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
				Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ornare tellus tincidunt nunc convallis id viverra fermentum lacus, morbi. Massa pulvinar erat sit eu tellus dolor quis.")
					.multilineTextAlignment(.center)
					.font(Font.system(size: 13, weight: .regular, design: .default))
					.lineSpacing(7)
					.padding(.horizontal, 46)
					.layoutPriority(1)
				Spacer()
					.frame(minHeight: 96)
				VStack(spacing: 16) {
					Button("Issuer") {
						self.isIssuer = true
						print("Issuer mode selected")
					}
					.buttonStyle(ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					Button("Verifier") {
						print("Making some magic")
					}
					.buttonStyle(ScreenPaddingButtonStyle.defaultBlueButtonStyleWithPadding)
					Button("Holder") {
						print("Making some magic")
					}
					.buttonStyle(ScreenPaddingButtonStyle.defaultWhiteButtonStyleWithPadding)
				}
				.padding(.horizontal, 46)
				.padding(.bottom, 40)
				if isIssuer {
					NavigationLink(
						destination: IssuerView(),
						isActive: $isIssuer,
						label: {
							EmptyView()
						})
				}
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

struct OnboardingPage_Previews: PreviewProvider {
    static var previews: some View {
		OnboardingPage()
			.previewGroup()
    }
}
