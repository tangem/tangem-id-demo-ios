//
//  UIImage+ScaleCrop.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/3/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

extension UIImage {
	func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
		var width: CGFloat
		var height: CGFloat
		var newImage: UIImage
		
		let size = self.size
		let aspectRatio =  size.width / size.height
		
		switch contentMode {
		case .scaleAspectFit:
			if aspectRatio > 1 {							// Landscape image
				width = dimension
				height = dimension / aspectRatio
			} else {                                        // Portrait image
				height = dimension
				width = dimension * aspectRatio
			}
			
		default:
			fatalError("UIImage.resizeToFit(): FATAL: Unimplemented ContentMode")
		}
		let renderFormat = UIGraphicsImageRendererFormat.default()
		renderFormat.opaque = opaque
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
		newImage = renderer.image {
			(context) in
			self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
		}
		return newImage
	}
	
	func cropToBounds(width: Double, height: Double) -> UIImage {
		
		let cgimage = cgImage!
		let contextImage: UIImage = UIImage(cgImage: cgimage)
		let contextSize: CGSize = contextImage.size
		var posX: CGFloat = 0.0
		var posY: CGFloat = 0.0
		var cgwidth: CGFloat = CGFloat(width)
		var cgheight: CGFloat = CGFloat(height)
		
		// See what size is longer and create the center off of that
		if contextSize.width > contextSize.height {
			posX = ((contextSize.width - contextSize.height) / 2)
			posY = 0
			cgwidth = contextSize.height
			cgheight = contextSize.height
		} else {
			posX = 0
			posY = ((contextSize.height - contextSize.width) / 2)
			cgwidth = contextSize.width
			cgheight = contextSize.width
		}
		
		let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
		
		// Create bitmap image from context using the rect
		let imageRef: CGImage = cgimage.cropping(to: rect)!
		
		// Create a new image based on the imageRef and rotate back to the original orientation
		let image: UIImage = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
		
		return image
	}
}


