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
	
}
