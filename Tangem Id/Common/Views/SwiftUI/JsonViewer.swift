//
//  JsonViewer.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/20/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct JsonViewer: View {
	
	var jsonMessage: String = ""
	
	@Environment(\.presentationMode) var presentationMode
	@State var isSharePresented: Bool = false
	
    var body: some View {
		VStack {
			ScrollView {
				Text(jsonMessage)
			}
			.padding(.top, 16)
			.padding(.horizontal)
			HStack {
				Spacer()
				Button(LocalizationKeys.Common.hide) {
					presentationMode.wrappedValue.dismiss()
				}
				.padding(.horizontal)
				Button(LocalizationKeys.Common.share) {
					self.isSharePresented = true
				}
				.sheet(isPresented: $isSharePresented, content: {
					ShareView(itemsToShare: [jsonMessage] as [Any], applicationActivities: nil)
				})
			}
			.foregroundColor(.tangemBlue)
			.padding()
		}
    }
}

struct JsonViewer_Previews: PreviewProvider {
    static var previews: some View {
        JsonViewer()
    }
}
