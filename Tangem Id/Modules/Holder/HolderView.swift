//
//  HolderView.swift
//  Tangem Id
//
//  Created by Andrew Son on 10/22/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct HolderView: View {
	
	@ObservedObject var viewModel: HolderViewModel
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HolderView_Previews: PreviewProvider {
    static var previews: some View {
        HolderView()
    }
}
