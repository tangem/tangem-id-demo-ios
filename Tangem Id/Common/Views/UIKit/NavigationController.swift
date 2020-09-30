//
//  NavigationController.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct NavigationController: UIViewControllerRepresentable {
	var configure: (UINavigationController) -> Void = { _ in }

	func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationController>) -> UIViewController {
		UIViewController()
	}
	func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationController>) {
		if let nc = uiViewController.navigationController {
			self.configure(nc)
		}
	}

}
