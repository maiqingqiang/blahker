//
//  BlockerListFeature.swift
//
//
//  Created by John Mai on 2024/1/14.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BlockerListFeature {
    struct State: Equatable {}

    enum Action: Equatable {}

    var body: some ReducerOf<Self> {
        Reduce(core)
    }

    func core(into state: inout State, action: Action) -> Effect<Action> {}
}
