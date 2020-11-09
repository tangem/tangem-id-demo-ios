//
//  ImagePicker.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/30/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

class ImagePickerWithOverlayController: UIImagePickerController {
	
	private let overlayName = "overlay"
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let topOffset: CGFloat = 72
		let bottomOffset: CGFloat = 72
		let overlayView = UIView(frame: CGRect(x: 0, y: topOffset, width: view.bounds.width, height: view.bounds.height - topOffset - bottomOffset))
		let viewBounds = overlayView.bounds
		
		let halfWidth = viewBounds.width / 2
		let smallRectPath = UIBezierPath(rect: CGRect(x: 0,
													  y: viewBounds.height / 2 - halfWidth,
													  width: viewBounds.width,
													  height: viewBounds.width))
		let pathBigRect = UIBezierPath(rect: viewBounds)
		let pathSmallRect = smallRectPath

		pathBigRect.append(pathSmallRect)
		pathBigRect.usesEvenOddFillRule = true

//		let fillLayer = CAShapeLayer()
//		fillLayer.name = overlayName
//		fillLayer.path = pathBigRect.cgPath
//		fillLayer.fillRule = .evenOdd
//		fillLayer.fillColor = UIColor.black.cgColor
//		fillLayer.opacity = 0.4
//		overlayView.layer.addSublayer(fillLayer)
		
		let borderLayer = CAShapeLayer()
		borderLayer.path = smallRectPath.cgPath
		borderLayer.strokeColor = UIColor.white.cgColor
		borderLayer.lineWidth = 2
		borderLayer.fillColor = UIColor.clear.cgColor
		overlayView.layer.addSublayer(borderLayer)
		
		overlayView.isUserInteractionEnabled = false
		
		cameraOverlayView = overlayView
	}
}

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	@Binding var image: UIImage?
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let picker = ImagePickerWithOverlayController()
		picker.sourceType = .camera
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let parent: ImagePicker
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
		
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
			if let uiImage = info[.originalImage] as? UIImage {
				parent.image = uiImage
				let resizedImage = uiImage.resizeImage(100, opaque: true).cropToBounds(width: 100, height: 100)
				parent.image = resizedImage
			}
			parent.presentationMode.wrappedValue.dismiss()
		}
		
	}
}
