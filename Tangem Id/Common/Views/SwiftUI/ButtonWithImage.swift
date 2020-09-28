//
//  ButtonWithImage.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ButtonWithImage: View {
	
	let image: UIImage
	let text: String
	let action: () -> Void
	let isLtr: Bool
	
	var body: some View {
		Button(action: action, label: {
			HStack(spacing: 12) {
				if isLtr {
					Image(uiImage: image)
				}
				Text(text)
					.foregroundColor(.tangemBlue)
				if !isLtr {
					Image(uiImage: image)
				}
			}
		})
	}
}
struct ButtonWithImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithImage(
			image: UIImage(named: "plus_blue")!,
			text: "Add photo",
			action: {},
			isLtr: true
		)
		.deviceForPreview(.iPhone7)
    }
}
