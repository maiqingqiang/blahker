//
//  BlockerListView.swift
//
//
//  Created by John Mai on 2024/1/14.
//

import ComposableArchitecture
import SwiftUI

struct BlockerListView: View {
    let store: StoreOf<BlockerListFeature>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    BlockerListView(store: .init(
        initialState: BlockerListFeature.State(),
        reducer: {
            BlockerListFeature()
        }
    ))
}
