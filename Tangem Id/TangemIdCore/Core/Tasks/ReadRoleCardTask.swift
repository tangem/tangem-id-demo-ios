//
//  ReadRoleCardTask.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

@available (iOS 13.0, *)
public class ReadRoleCardTask: CardSessionRunnable {
	public typealias CommandResponse = Card
	
	public init(targetCardType: ProductMask) {
		self.targetCardType = targetCardType
	}
	
	private let targetCardType: ProductMask
	
	public func run(in session: CardSession, completion: @escaping CompletionResult<Card>) {
		guard isValidCard(type: targetCardType, in: session, shouldStopSessionIfNotValid: true) else {
			completion(.failure(.underlying(error: TangemIdError.cancelledWithoutError)))
			return
		}
		let read = ScanTask()
		read.run(in: session, completion: completion)
	}
	
}

extension ReadRoleCardTask: RoleCardTypeChecker { }
