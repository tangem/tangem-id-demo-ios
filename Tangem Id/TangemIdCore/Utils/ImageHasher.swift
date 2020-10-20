//
//  ImageHasher.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/5/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit
import CryptoSwift

protocol ImageHasher: class {
	var hash: String { get }
	var base64: String { get }
	
	func hash(image: UIImage, withQuality quality: CGFloat)
}

class JpegSha3ImageHasher: ImageHasher {
	private(set) var hash: String = ""
	private(set) var base64: String = ""
	
	func hash(image: UIImage, withQuality quality: CGFloat = 0.1) {
		guard let imageData = image.jpegData(compressionQuality: quality) else {
			return
		}
		base64 = base64ToBase64url(base64: imageData.base64EncodedString())
		hash = base64ToBase64url(base64: imageData.sha3(.sha256).base64EncodedString())
	}
	
	func base64ToBase64url(base64: String) -> String {
		let base64url = base64
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
		return base64url
	}
}
