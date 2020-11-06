//
//  ScreenPaddingButtonStyle.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//

import SwiftUI

enum ScreenSidePaddingSize {
	case width(left: CGFloat, right: CGFloat, height: CGFloat)
	case height(top: CGFloat, bottom: CGFloat, width: CGFloat)
	
	static let `default` = ScreenSidePaddingSize.width(left: 46, right: 46, height: 48)
	
	var width: CGFloat {
		let screenSize = UIScreen.mainScreenSize
		switch self {
		case let .width(left, right, _):
			return screenSize.width - left - right
		case .height(_, _, let width):
			return width
		}
	}
	
	var size: CGSize {
		let screenSize = UIScreen.mainScreenSize
		switch self {
		case let .width(left, right, height):
			return .init(width: screenSize.width - left - right, height: height)
		case let .height(top, bottom, width):
			return .init(width: width, height: screenSize.height - top - bottom)
		}
	}
}

enum ButtonColorStyle {
	case blue
	case white
	case transparentBlue
	
	var defaultColor: Color {
		switch self {
		case .blue:
			return .tangemBlue
		case .white:
			return .white
		case .transparentBlue:
			return .white
		}
	}
	
	var pressedColor: Color {
		switch self {
		case .blue:
			return .tangemLightBlue
		case .white:
			return .mainBackground
		case .transparentBlue:
			return .white
		}
	}
	
	var fontColor: Color {
		switch self {
		case .blue: return .white
		case .white: return .tangemBlack
		case .transparentBlue: return .tangemBlue
		}
	}
	
	var isWithShadow: Bool {
		switch self {
		case .blue, .white: return true
		case .transparentBlue: return false
		}
	}
}

struct SideInsets {
	let leading: CGFloat
	let trailing: CGFloat
}

struct ScreenPaddingButtonStyle: ButtonStyle {
	
	static let defaultBlueButtonStyleWithPadding = ScreenPaddingButtonStyle(height: 42, cornerRadius: 4, colorStyle: .blue)
	static let defaultWhiteButtonStyleWithPadding = ScreenPaddingButtonStyle(height: 42, cornerRadius: 4, colorStyle: .white)
	static let transparentBackWithBlueText = ScreenPaddingButtonStyle(height: 22, cornerRadius: 4, colorStyle: .transparentBlue)
	
	var height: CGFloat = 46
	var cornerRadius: CGFloat = 4
	var colorStyle: ButtonColorStyle = .blue
	var isDisabled: Bool = false
	
	func makeBody(configuration: Configuration) -> some View {
		configuration
			.label
			.font(Font.system(size: 16, weight: .medium, design: .default))
			.foregroundColor(colorStyle.fontColor)
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: height)
			.background(
				configuration.isPressed ?
					colorStyle.pressedColor :
					colorStyle.defaultColor)
			.cornerRadius(cornerRadius)
			.shadow(color: Color.tangemBlack.opacity(colorStyle.isWithShadow ? 0.2 : 0.0), radius: 3, x: 0, y: 1)
			.overlay(!isDisabled ? Color.clear : Color.white.opacity(0.4))
	}
	
	
}

extension ButtonStyle {
	
}

struct ScreenPaddingButtonStyle_Previews: PreviewProvider {
	static var previews: some View {
		VStack(alignment: .center, spacing: 16.0) {
			Button(action:{}){ Text("Issuer") }
				.buttonStyle(ScreenPaddingButtonStyle(colorStyle: .blue))
			
			
			Button(action: {}) { Text("Holder") }
				.buttonStyle(ScreenPaddingButtonStyle(colorStyle: .white))
			
			Button(action: {}) { Text("Verifier") }
				.buttonStyle(ScreenPaddingButtonStyle(colorStyle: .blue, isDisabled: true))
			
			Button(action: {}) { Text("Holder") }
				.buttonStyle(ScreenPaddingButtonStyle(colorStyle: .white, isDisabled: true))
		}
	}
}
