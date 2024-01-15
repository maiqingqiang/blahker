//
//  AboutView.swift
//
//
//  Created by John Mai on 2024/1/14.
//

import ComposableArchitecture
import SwiftUI

struct AboutView: View {
    let store: StoreOf<AboutFeature>

    var body: some View {
        List {
            Section {
                blockerListCell
                reportCell
            }
            Section {
                rateCell
                shareCell
                aboutCell
            }
        }
        .navigationTitle(Text("关于"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }

    @MainActor
    @ViewBuilder
    private var blockerListCell: some View {
        Button(action: {
            store.send(.tapBlockerListCell)
        }, label: {
            Text("已阻挡的盖版广告网站")
        })
    }

    @MainActor
    @ViewBuilder
    private var reportCell: some View {
        Button(action: {
            store.send(.tapReportCell)
        }, label: {
            VStack(alignment: .leading) {
                Text("回报广告网站或问题")
                Text("附上屏幕截图，以便排查")
                    .font(.footnote)
            }
        })
    }

    @MainActor
    @ViewBuilder
    private var rateCell: some View {
        Button(action: {
            store.send(.tapRateCell)
        }, label: {
            Text("为我们评分")
        })
    }

    @MainActor
    @ViewBuilder
    private var shareCell: some View {
        ShareLink(item: .appStore) {
            Text("推荐给朋友")
        }
    }

    @MainActor
    @ViewBuilder
    private var aboutCell: some View {
        Button(action: {
            store.send(.tapAboutCell)
        }, label: {
            VStack(alignment: .leading) {
                Text("关于 Blahker 与常见问题")
                Text("v1.0.0(11)")
                    .font(.footnote)
            }
        })
    }
}

#Preview {
    NavigationStack {
        AboutView(store: .init(
            initialState: AboutFeature.State(),
            reducer: {
                AboutFeature()
            }
        ))
    }
    .preferredColorScheme(.dark)
}
