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
        WithViewStore(store, observe: \.ruleItems) { viewStore in
            let ruleItems = viewStore.state

            List {
                ForEach(ruleItems) { ruleItem in
                    VStack(alignment: .leading) {
                        Text(ruleItem.title)
                            .font(.headline)
                            .lineLimit(1)
                        Text(ruleItem.description)
                            .font(.subheadline)
                            .lineLimit(3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(Text("已阻挡的盖板广告网站"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        BlockerListView(store: .init(
            initialState: BlockerListFeature.State(
                ruleItems: [
                    .init(
                        title: "*.baidu.com",
                        description: ".iframe-ads-link"
                    )
                ]
            ),
            reducer: {
                BlockerListFeature()
            }
        ))
    }
    .preferredColorScheme(.dark)
}
