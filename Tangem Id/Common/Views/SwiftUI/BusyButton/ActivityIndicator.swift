//
//  ActivityIndicator.swift
//  Tangem Id
//
//  Created by Andrew Son on 11/6/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
	
	var isAnimating: Bool = true
	let indicatorSettings: IndicatorSettings
	
	func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
		let indicator = UIActivityIndicatorView(style: indicatorSettings.indicatorStyle)
		indicator.color = indicatorSettings.color
		return indicator
	}
	
	func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
		isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}
