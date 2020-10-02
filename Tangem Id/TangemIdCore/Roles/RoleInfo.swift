//
//  RoleInfo.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import UIKit

protocol RoleInfo {
	var role: Role { get }
	var title: String { get }
	var description: String? { get }
	var image: UIImage? { get }
}

protocol IssuerRoleInfoType: RoleInfo {
	var didWalletAddress: String { get }
	var qrImage: UIImage? { get }
}

extension IssuerRoleInfoType {
	var role: Role { .issuer }
}

struct IssuerRoleInfo: IssuerRoleInfoType {
	var didWalletAddress: String
	var qrImage: UIImage?
	var title: String
	var description: String?
	var image: UIImage?
	
	static var emptyInfo = IssuerRoleInfo(didWalletAddress: "did:ethr:", qrImage: nil, title: "Some authorized issuer", description: "", image: nil)
}

struct VerifierRoleInfo: RoleInfo {
	var role: Role { .verifier }
	var title: String = ""
	var description: String?
	var image: UIImage?
}

//class RoleInfo {
//	internal init(role: Role, title: String, description: String?, image: UIImage?) {
//		self.role = role
//		self.title = title
//		self.description = description
//		self.image = image
//	}
//
//	let role: Role
//	let title: String
//	let description: String?
//	let image: UIImage?
//}

