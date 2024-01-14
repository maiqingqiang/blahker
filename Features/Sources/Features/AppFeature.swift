//
//  AppFeature.swift
//  Blahker
//
//  Created by John Mai on 2024/1/3.
//

import ComposableArchitecture
import ContentBlockerService
import Foundation

@Reducer
struct AppFeature {
    struct State: Equatable {
        var home: HomeFeature.State = .init()
    }

    enum Action: Equatable {
        case home(HomeFeature.Action)
    }

    @Dependency(\.contentBlockerService) var contentBlockerService

    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }

        Reduce(core)
    }

    func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .home:
            return .none
        }
    }
}
