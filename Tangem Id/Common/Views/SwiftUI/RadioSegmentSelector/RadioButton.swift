//
//  RadioButton.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct Ring: Shape {
	
	var degree: Double
	
	var animatableData: Double {
		get { degree }
		set { degree = newValue}
	}
	
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.addArc(
				center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2),
				radius: rect.size.height / 2,
				startAngle: Angle(degrees: -90),
				endAngle: Angle(degrees: degree),
				clockwise: false
			)
		}
	}
}

struct RadioButton: View {
	
	let isSelected: Bool
	
    var body: some View {
		GeometryReader { reader in
			ZStack {
				Ring(degree: 270)
					.stroke(self.isSelected ? Color.tangemBlue : Color.gray, lineWidth: 2)
					.animation(Animation.linear.speed(2))
				Circle()
					.fill(Color.tangemBlue)
					.padding(.all, 4)
					.scaleEffect(self.isSelected ? 1.0 : 0.001)
					.animation(
						self.isSelected ?
							Animation.spring(response: 0.15, dampingFraction: 0.45, blendDuration: 0) :
							Animation.linear.speed(2))
			}
		}
		.background(Color.white)
		.aspectRatio(1.0,
					 contentMode: .fit)
		.padding(.all, 10)
    }
}

struct RadioButton_Previews: PreviewProvider {
    static var previews: some View {
		RadioButton(isSelected: false)
			.previewLayout(.fixed(width: 40, height: 40))
    }
}
