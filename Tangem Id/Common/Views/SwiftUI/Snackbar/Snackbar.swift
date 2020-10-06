//
//  Snackbar.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/3/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct SnackData {
	var message: String
	var type: SnackType
	
	static let emptySnack = SnackData(message: "", type: .info)
}

enum SnackType {
	case info
	case warning
	case success
	case error
	
	var tintColor: Color {
		switch self {
		case .info:
			return Color(red: 67/255, green: 154/255, blue: 215/255)
		case .success:
			return Color.green
		case .warning:
			return Color.yellow
		case .error:
			return Color.red
		}
	}
}

struct SnackModifier: ViewModifier {
	
	@Binding var data: SnackData
	@Binding var show: Bool
	
	@State private var task: DispatchWorkItem?
	
	func body(content: Content) -> some View {
		ZStack {
			content
			if show {
				VStack {
					Spacer()
					HStack {
						VStack(alignment: .leading, spacing: 2) {
							Text(data.message)
								.font(Font.system(size: 15, weight: .regular, design: .default))
						}
						Spacer()
					}
					.foregroundColor(Color.white)
					.padding()
					.background(data.type.tintColor)
					.cornerRadius(8)
					.shadow(radius: 4)
				}
				.padding()
				.animation(.easeOut(duration: 0.6))
				.transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
				
				.onTapGesture {
					withAnimation {
						self.show = false
					}
				}.onAppear {
					self.task = DispatchWorkItem {
						withAnimation {
							self.show = false
						}
					}
					// Auto dismiss after 5 seconds, and cancel the task if view disappear before the auto dismiss
					DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: self.task!)
				}
				.onDisappear {
					self.task?.cancel()
				}
			}
			
		}
	}
}

extension View {
	func snack(data: Binding<SnackData>, show: Binding<Bool>) -> some View {
		self.modifier(SnackModifier(data: data, show: show))
	}
}
