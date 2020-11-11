//
//  ModalLink.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/27/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct ModalLink<T: View>: View {
	@Binding var isPresented: Bool
	
	var destination: T
	
	var body: some View {
		EmptyView()
			.sheet(isPresented: $isPresented, content: {
				self.destination
			})
	}
}
