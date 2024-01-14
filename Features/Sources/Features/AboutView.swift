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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AboutView(store: .init(
        initialState: AboutFeature.State(),
        reducer: {
            AboutFeature()
        }
    ))
}
