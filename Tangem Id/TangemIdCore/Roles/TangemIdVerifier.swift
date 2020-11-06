//
//  TangemIdVerifier.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/2/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import Foundation
import TangemSdk
import SwiftCBOR

typealias TangemVerifierManager = TangemIdSdk<TangemIdVerifier>
 
 final class TangemIdVerifier: ActionExecutioner {

	private let tangemSdk: TangemSdk

	init(tangemSdk: TangemSdk) {
		self.tangemSdk = tangemSdk
	}

	var executionerInfo: RoleInfo {
		VerifierRoleInfo()
	}
	
	private var savedFiles: [File] = []

	func execute(action: VerifierAction) {
		switch action {
		case .readHoldersCredentials:
			break
		case .deleteSavedFiles:
//			readFiles()
			break
		}
	}

	private func readFiles() {
		tangemSdk.readFiles { (result) in
			switch result {
			case .success(let response):
				print(response)
				print("Number of files on card", response.files.count)
				response.files.forEach {
					guard let cbor = try? CBOR.decode($0.fileData.bytes) else {
						return
					}
					print(cbor)
				}
				self.savedFiles = response.files
			case .failure(let error):
				print(error)
			}
		}
	}
 }
