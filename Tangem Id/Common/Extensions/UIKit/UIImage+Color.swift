//
//  UIImage+Color.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/26/20.
//

import UIKit

extension UIColor {
	func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { rendererContext in
			self.setFill()
			rendererContext.fill(CGRect(origin: .zero, size: size))
		}
	}
}
