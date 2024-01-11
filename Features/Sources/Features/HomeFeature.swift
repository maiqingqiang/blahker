//
//  File.swift
//
//
//  Created by John Mai on 2024/1/4.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
    struct State: Equatable {
        var isEnabledContentBlocker = false
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case scenePhaseBecomeActive
        case userEnableContentBlocker(Bool)
        case tapDontTapMeButton
        case tapRefreshButton
        case tapAboutButton
        
        enum Alert {
            case okToReloadContentBlocker
            case smallDonation
            case mediumDonation
            case largeDonation
            case rate5Star
        }
    }
    
    @Dependency(\.contentBlockerService) var contentBlockerService
    @Dependency(\.openURL) var openURL
    
    var body: some ReducerOf<Self> {
        Reduce(core)
            .ifLet(\.$alert, action: \.alert)
    }
    
    func core(into state: inout State, action: Action) -> Effect<Action> {
        var checkUserEnabledContentBlocker: Effect<Action> {
            .run { send in
                let extensionID = "com.elaborapp.Blahker.ContentBlocker"
                let isEnabled = await contentBlockerService.checkUserEnabledContentBlocker(extensionID)
                
                await send(.userEnableContentBlocker(isEnabled))
            }
        }
        
        let pleaseEnableContentBlockerAlert = AlertState<HomeFeature.Action.Alert>(
            title: TextState("请开启扩展"),
            message: TextState("请打开「设置」>「Safari」>「扩展」，并启用Blahker"),
            buttons: [
                ButtonState(
                    action: .okToReloadContentBlocker,
                    label: {
                        TextState("确定")
                    }
                ),
                ButtonState(
                    role: .cancel,
                    label: {
                        TextState("取消")
                    }
                )
            ]
        )
        
        switch action {
        case .alert(.presented(.largeDonation)):
            return .none
        case let .alert(.presented(alert)):
            switch alert {
            case .okToReloadContentBlocker:
                state.alert = pleaseEnableContentBlockerAlert
                return .none
            case .smallDonation:
                return .none
            case .mediumDonation:
                return .none
            case .largeDonation:
                return .none
            case .rate5Star:
                return .run { _ in
                    let url = URL(string: "https://apps.apple.com/tw/app/blahker-%E5%B7%B4%E6%8B%89%E5%89%8B/id1182699267")!
                    await openURL(url)
                }
            }
            
        case .alert(.dismiss):
            return .none
        case .scenePhaseBecomeActive:
            return checkUserEnabledContentBlocker
        case let .userEnableContentBlocker(isEnabled):
            state.isEnabledContentBlocker = isEnabled
            
            if isEnabled {
            } else {
                state.alert = pleaseEnableContentBlockerAlert
            }
            
            return .none
        case .tapDontTapMeButton:
            state.alert = AlertState(
                title: TextState("支持开发者"),
                message: TextState("Blahker的维护包含不断更新挡广告清单。如果有你的支持一定会更好～"),
                buttons: [
                    ButtonState(
                        action: .smallDonation,
                        label: {
                            TextState("打赏小小费")
                        }
                    ),
                    ButtonState(
                        action: .mediumDonation,
                        label: {
                            TextState("打赏小费")
                        }
                    ),
                    ButtonState(
                        action: .largeDonation,
                        label: {
                            TextState("破费")
                        }
                    ),
                    ButtonState(
                        action: .rate5Star,
                        label: {
                            TextState("我不出钱，给个五星好评总行了吧")
                        }
                    ),
                    ButtonState(
                        role: .cancel,
                        label: {
                            TextState("算了吧，不值得")
                        }
                    ),
                ]
            )
            return .none
        case .tapRefreshButton:
            return checkUserEnabledContentBlocker
        case .tapAboutButton:
            return .none
        }
    }
}
