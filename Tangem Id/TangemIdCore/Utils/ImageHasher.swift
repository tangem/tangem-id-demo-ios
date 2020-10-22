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
	func imageData(from base64: String) -> Data?
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
	
	func imageData(from base64: String) -> Data? {
		let withoutNewLines = base64.replacingOccurrences(of: "\n", with: "")
		let normalizedBase64 = base64urlToBase64(base64url: withoutNewLines)
		guard let data = Data(base64Encoded: normalizedBase64) else { return nil }
		return data
	}
	
	func base64ToBase64url(base64: String) -> String {
		let base64url = base64
			.replacingOccurrences(of: "+", with: "-")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: "=", with: "")
		return base64url
	}
	
	func base64urlToBase64(base64url: String) -> String {
		var base64 = base64url
			.replacingOccurrences(of: "-", with: "+")
			.replacingOccurrences(of: "_", with: "/")
		if base64.count % 4 != 0 {
			base64.append(String(repeating: "=", count: 4 - base64.count % 4))
		}
		return base64
	}
}
