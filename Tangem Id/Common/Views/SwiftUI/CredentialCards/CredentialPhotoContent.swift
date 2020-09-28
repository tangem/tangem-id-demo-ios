//
//  CredentialPhotoContent.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct CredentialPhotoContent: View {
	
	@Binding var image: UIImage
	
    var body: some View {
		ZStack {
			Color.photoBackground
				.padding(.bottom, 16)
			Image(uiImage: image)
				.resizable(resizingMode:.stretch)
				.background(Color.red)
				.frame(width: 201, height: 133)
				.padding(.vertical, 8)
				.padding(.bottom, 16)
		}
    }
}

struct CredentialPhotoContent_Previews: PreviewProvider {
    static var previews: some View {
		CredentialPhotoContent(image: .constant(#imageLiteral(resourceName: "dude")))
    }
}
