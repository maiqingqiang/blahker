//
//  File.swift
//  
//
//  Created by John Mai on 2024/1/14.
//

import ComposableArchitecture
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    let store: StoreOf<AppFeature> = .init(
        initialState: AppFeature.State(),
        reducer: {
            AppFeature()._printChanges()
        }
    )

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        store.send(.home(.appDidFinishLaunching))

        return true
    }
}
