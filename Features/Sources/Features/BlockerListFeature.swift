//
//  BlockerListFeature.swift
//
//
//  Created by John Mai on 2024/1/14.
//

import ComposableArchitecture
import Foundation
import Models

@Reducer
struct BlockerListFeature {
    struct State: Equatable {
        var ruleItems: [RuleItem] = []
    }

    enum Action: Equatable {}

    var body: some ReducerOf<Self> {
        Reduce(core)
    }

    func core(into state: inout State, action: Action) -> Effect<Action> {}
}

struct RuleItem: Equatable, Identifiable {
    let id = UUID()

    var title: String
    var description: String
}