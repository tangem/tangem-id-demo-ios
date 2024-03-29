//
//  Color+.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//

import SwiftUI

extension Color {
	
	@nonobjc static var mainBackground: Color {
		Color(UIColor.mainBackground)
	}
	
	static var tangemBlue: Color {
		Color(UIColor.tangemBlue)
	}
	
	static var tangemLightBlue: Color {
		Color(UIColor.tangemLightBlue)
	}
	
	static var tangemBlack: Color {
		Color(UIColor.tangemBlack)
	}
	
	static var photoBackground: Color {
		Color(UIColor.photoBackground)
	}
	
	static var placeholderTextColor: Color {
		Color(UIColor.placeholderTextColor)
	}
	
	static var error: Color {
		Color(UIColor.error)
	}
	
	static var offline: Color {
		Color(UIColor.offline)
	}
	
	static var success: Color {
		Color(UIColor.success)
	}
	
	static var tangemDarkGray: Color {
		Color(UIColor.tangemDarkGray)
	}
	
}

extension UIColor {
	@nonobjc static var mainBackground: UIColor {
		UIColor(named: "MainBackground")!
	}
	
	@nonobjc static var tangemBlue: UIColor {
		UIColor(named: "TangemBlue")!
	}
	
	@nonobjc static var tangemLightBlue: UIColor {
		UIColor(named: "TangemLightBlue")!
	}
	
	@nonobjc static var tangemBlack: UIColor {
		UIColor(named: "TangemBlack")!
	}
	
	@nonobjc static var photoBackground: UIColor {
		UIColor(named: "PhotoBackground")!
	}
	
	@nonobjc static var placeholderTextColor: UIColor {
		UIColor(named: "PlaceholderTextColor")!
	}
	
	@nonobjc static var error: UIColor {
		UIColor(named: "Error")!
	}
	
	@nonobjc static var offline: UIColor {
		UIColor(named: "Offline")!
	}
	
	@nonobjc static var success: UIColor {
		UIColor(named: "Success")!
	}
	
	@nonobjc static var tangemDarkGray: UIColor {
		UIColor(named: "TangemDarkGray")!
	}
	
}
