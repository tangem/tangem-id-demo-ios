//
//  TangemIdAppError.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/1/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import TangemSdk

enum TangemIdAppError: LocalizedError {
	case idCoreError(error: TangemIdError)
	case tangemSdkError(error: String)
}
