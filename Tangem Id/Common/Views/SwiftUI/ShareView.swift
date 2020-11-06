//
//  ShareView.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/20/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {

	let itemsToShare: [Any]
	let applicationActivities: [UIActivity]?

	func makeUIViewController(context: UIViewControllerRepresentableContext<ShareView>) -> UIActivityViewController {
		return UIActivityViewController(activityItems: itemsToShare,
										applicationActivities: applicationActivities)
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController,
								context: UIViewControllerRepresentableContext<ShareView>) {

	}
}
