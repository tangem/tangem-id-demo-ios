//
//  Command.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk
import Foundation

protocol Command {
	associatedtype Result: ResponseCodable
	var role: Role { get }
	var validCardType: ProductMask { get }
	func execute(completion: CompletionResult<Result>)
}
