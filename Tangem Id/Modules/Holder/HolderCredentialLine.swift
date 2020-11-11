//
//  HolderCredentialLine.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/25/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct HolderCredentialLine: View {
	
	var name: LocalizedStringKey
	var isPrivate: Bool
	var isEditing: Bool
	
	var deleteAction: () -> Void
	var togglePrivacyAction: () -> Void
	
	var body: some View {
		HStack(alignment: .center) {
			Text(name)
			Spacer()
			if isEditing {
				Button(action: deleteAction, label: {
					Image(systemName: "minus.circle.fill")
						.frame(width: 18, height: 18)
						.padding(.horizontal, 8)
						.padding(.vertical)
						.foregroundColor(.red)
				})
				.animation(.easeInOut)
				.transition(.opacity)
			}
			Button(action: togglePrivacyAction, label: {
				Image(systemName: isPrivate ? "lock.fill" : "lock.open")
					.frame(width: 18, height: 18)
					.padding()
			})
			.disabled(!isEditing)
			
		}
	}
	
}
