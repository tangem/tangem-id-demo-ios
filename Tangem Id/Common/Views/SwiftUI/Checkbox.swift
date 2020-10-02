//
//  Checkbox.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct Checkbox: View {
	
	var isSelected: Bool
	
    var body: some View {
		ZStack {
			Rectangle()
				.fill(Color.clear)
				.frame(width: 18, height: 18)
				.overlay(
					RoundedRectangle(cornerRadius: 2)
						.stroke(Color.tangemBlack, lineWidth: 2)
				)
				.opacity(isSelected ? 0.0 : 1.0)
				.animation(Animation.easeInOut.speed(2))
			ZStack {
				GeometryReader { geometry in
					Rectangle()
						.fill(Color.tangemBlue)
						.cornerRadius(2)
						.frame(width: 20, height: 20)
					Path { path in
						path.move(to: CGPoint(x: 4, y: 10))
						path.addLine(to: CGPoint(x: 8.5, y: 14))
						path.addLine(to: CGPoint(x: 16, y: 6))
					}
					
					.stroke(style: StrokeStyle(lineWidth: 1.5, lineCap: .square, lineJoin: .miter))
					.animation(.easeIn)
					.foregroundColor(.white)
					
				}
				.frame(width: 20, height: 20)
			}
			.scaleEffect(isSelected ? 1.0 : 0.001)
			.animation(
				(!isSelected ?
					Animation.easeIn :
					Animation.spring(response: 0.35, dampingFraction: 0.35, blendDuration: 0
					))
					.speed(2))
		}
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
		Checkbox(isSelected: true)
			.previewLayout(.fixed(width: 40, height: 40))
    }
}
