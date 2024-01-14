//
//  BlahkerApp.swift
//  Blahker
//
//  Created by John Mai on 2024/1/3.
//

import ComposableArchitecture
import SwiftUI

@main
struct BlahkerApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            AppView(store: appDelegate.store)
        }
    }
}



struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        HomeView(store: store.scope(state: \.home, action: \.home))
    }
}
