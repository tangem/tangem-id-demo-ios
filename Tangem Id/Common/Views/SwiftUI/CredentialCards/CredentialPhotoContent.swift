//
//  CredentialPhotoContent.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct CredentialPhotoContent: View {
	
	var image: UIImage
	var isSquare: Bool = false
	
	init(image: UIImage, isSquare: Bool = false) {
		self.image = image
		self.isSquare = isSquare
	}
	
    var body: some View {
		ZStack {
			Color.photoBackground
				.padding(.bottom, 16)
			Image(uiImage: image)
				.resizable(resizingMode: .stretch)
				.aspectRatio(contentMode: .fill)
				.frame(width: !isSquare ? 201 : 150, height: !isSquare ? 133 : 150)
				.clipped()
				.padding(.vertical, 8)
				.padding(.bottom, 16)
		}
    }
}

struct CredentialPhotoContent_Previews: PreviewProvider {
    static var previews: some View {
		CredentialPhotoContent(image: #imageLiteral(resourceName: "dude"))
    }
}
