//
//  UIApplication+.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/19/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

extension UIApplication {
	
	/// Returns top view controller. If there UINavigationController of UITabBarController returns embended view controller
	class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
		if let navigationController = controller as? UINavigationController {
			return topViewController(controller: navigationController.visibleViewController)
		}
		if let tabController = controller as? UITabBarController {
			if let selected = tabController.selectedViewController {
				return topViewController(controller: selected)
			}
		}
		if let presented = controller?.presentedViewController {
			return topViewController(controller: presented)
		}
		return controller
	}
	
	class func rootViewController() -> UIViewController? {
		let rootVC = UIApplication.shared.keyWindow?.rootViewController
		return rootVC
	}
	
}

