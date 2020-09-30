//
//  NavigationBar.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ArrowBack: View {
	let action: () -> Void
	
	var body: some View {
		Button(action: action, label: {
			Image(systemName: "arrow.left")
				.foregroundColor(.tangemBlack)
		})
		.padding()
	}
}

struct NavigationBar<LeftButtons: View, RightButtons: View>: View {
	
	private let title: String
	private let leftButtons: LeftButtons
	private let rightButtons: RightButtons
	private let titleFont: Font
	private let titleColor: Color
	
	init(
		title: String,
		titleFont: Font = .navigationTitle,
		titleColor: Color = .tangemBlack,
		@ViewBuilder leftItems: () -> LeftButtons,
		@ViewBuilder rightItems: () -> RightButtons
	) {
		self.title = title
		self.titleFont = titleFont
		self.titleColor = titleColor
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
				.foregroundColor(titleColor)
		}
		.frame(height: 44)
	}
}

extension NavigationBar where LeftButtons == ArrowBack, RightButtons == EmptyView {
	init(
		title: String,
		titleFont: Font = .navigationTitle,
		titleColor: Color = .tangemBlack,
		presentationMode:  Binding<PresentationMode>
	) {
		leftButtons = ArrowBack {
			presentationMode.wrappedValue.dismiss()
		}
		rightButtons = EmptyView()
		self.title = title
		self.titleFont = titleFont
		self.titleColor = titleColor
	}
}
