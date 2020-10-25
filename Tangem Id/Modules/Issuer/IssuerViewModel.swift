//
//  IssuerViewModel.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/28/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI
import Combine
import CoreImage.CIFilterBuiltins

class IssuerViewModel: ObservableObject, Equatable, SnackMessageDisplayable {
	static func == (lhs: IssuerViewModel, rhs: IssuerViewModel) -> Bool {
		lhs.isCreatingCredentials == rhs.isCreatingCredentials
	}
	
	private let moduleAssembly: ModuleAssemblyType
	private let issuerManager: TangemIssuerManager
	
	@Published var isCreatingCredentials: Bool? = false
	@Published var snackMessage: SnackData = .emptySnack
	@Published var isShowingSnack: Bool = false
	
	var qrImage: UIImage = #imageLiteral(resourceName: "qr")
	
	@Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
	
	private(set) var createCredentialsLink: AnyView = AnyView(EmptyView())
	private(set) var issuerInfo: IssuerRoleInfoType
	
	var disposable = Set<AnyCancellable>()
	
	init(moduleAssembly: ModuleAssemblyType, issuerInfo: IssuerRoleInfoType, issuerManager: TangemIssuerManager) {
		self.moduleAssembly = moduleAssembly
		self.issuerInfo = issuerInfo
		self.issuerManager = issuerManager
		if let qr = generateQr(from: issuerInfo.didWalletAddress) {
			self.qrImage = qr
		}
	}
	
	func createNewCredentials() {
		issuerManager.execute(action: .getHolderAddress { [weak self] (result) in
			guard let self = self else { return }
			switch result {
			case .success:
				self.createCredentialsLink = try! self.moduleAssembly.assembledView(for: .issuerCreateCredentials(manager: self.issuerManager))
				self.isCreatingCredentials = true
			case .failure(let error):
				self.showErrorSnack(message: error.localizedDescription)
			}
		})
	}
	
	private func generateQr(from string: String) -> UIImage? {
		let context = CIContext()
		let filter = CIFilter.qrCodeGenerator()
		let data = Data(string.utf8)
		filter.setValue(data, forKey: "inputMessage")
		
		if let outputImage = filter.outputImage {
			if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
				return UIImage(cgImage: cgimg)
			}
		}
		return nil
	}
	
}
