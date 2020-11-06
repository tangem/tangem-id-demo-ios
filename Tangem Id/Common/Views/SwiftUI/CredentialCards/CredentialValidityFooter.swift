//
//  CredentialValidityFooter.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/21/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct CredentialValidityFooter: View {
	
	var status: VerificationStatus = .valid
	var issuerInfo: IssuerVerificationInfo = .init(address: "did:eth:0x3334r34tr33tygeg3rg3rtg34gr", isTrusted: true)
	
    var body: some View {
		VStack(alignment: .leading) {
			(Text(LocalizationKeys.Modules.Verifier.status) + Text(status.description).bold().foregroundColor(Color(status.color)))
				.font(.system(size: 14))
				.padding(.bottom, 8)
			(Text(LocalizationKeys.Modules.Verifier.issuedBy) +
				Text(issuerInfo.isTrusted ? LocalizationKeys.Modules.Verifier.trusted : LocalizationKeys.Modules.Verifier.unknown)
				.foregroundColor(issuerInfo.isTrusted ? .success : .error).bold()
				+ Text(LocalizationKeys.Modules.Verifier.issuer) + Text(issuerInfo.address))
				.font(.system(size: 14))
		}
		.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal)
		.padding(.bottom, 20)
    }
}

struct CredentialValidityFooter_Previews: PreviewProvider {
    static var previews: some View {
        CredentialValidityFooter()
    }
}
