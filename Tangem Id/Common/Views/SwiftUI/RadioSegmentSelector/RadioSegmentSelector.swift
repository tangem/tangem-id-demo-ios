//
//  RadioSegmentSelector.swift
//  Tangem Id
//
//  Created by Andrew Son on 9/29/20.
//  Copyright © 2020 Tangem AG. All rights reserved.
//

import SwiftUI

struct SegmentData: Identifiable {
	let id = UUID()
	let title: String
	var selectionIndex: Int
}

struct RadioSegmentButton: View {
	
	let title: String
	let index: Int
	var selectionIndex: Int
	
	let selectionAction: ((Int) -> Void)?
	
	var body: some View {
		HStack(spacing: 0) {
			Text(title)
				.font(.credentialCardContent)
			RadioButton(isSelected: selectionIndex == index)
				.frame(width: 40, height: 40)
			
		}
		.frame(minWidth: 0, maxWidth: .infinity)
		.onTapGesture(perform: {
//			self.selectionIndex = index
			self.selectionAction?(self.index)
		})
	}
}

struct RadioSegmentSelector: View {
	
	private(set) var segments: [SegmentData] = []
	
	var selectedIndex: Int
	let selectionAction: ((Int) -> Void)?
	
    var body: some View {
		HStack(spacing: 0) {
			ForEach(segments) { segment in
				RadioSegmentButton(title: segment.title, index: segment.selectionIndex, selectionIndex: self.selectedIndex, selectionAction: self.selectionAction)
			}
		}
		.padding(.bottom, 10)
    }
}

struct RadioSegmentSelector_Previews: PreviewProvider {
	@State static var selectedIndex = -1
	
    static var previews: some View {
        RadioSegmentSelector(segments: [
			SegmentData(title: "Male", selectionIndex: 0),
			SegmentData(title: "Female", selectionIndex: 1),
			SegmentData(title: "Other", selectionIndex: 2)
		], selectedIndex: selectedIndex, selectionAction: {
			selectedIndex = $0
		})
			.previewLayout(.fixed(width: 375, height: 200))
    }
}
