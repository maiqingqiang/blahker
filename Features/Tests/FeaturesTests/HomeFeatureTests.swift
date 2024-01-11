//
//  HomeFeatureTests.swift
//  BlahkerTests
//
//  Created by John Mai on 2024/1/3.
//
import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class HomeFeatureTests: XCTestCase {
    static let pleaseEnableContentBlockerAlert = AlertState<HomeFeature.Action.Alert>(
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

    func testAppLaunch_userHaventEnableContentBlocker() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
        }

        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = Self.pleaseEnableContentBlockerAlert
        }
    }

    func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
        }

        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
    }

    func testAppLaunch_userAlreadyEnableContentBlocker_laterEnabled() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
        }

        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = Self.pleaseEnableContentBlockerAlert
        }

        store.dependencies.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
        }
    }

    func testAlert_rate5Star_openAppStoreURL() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.openURL = .init(handler: { url in
                XCTAssertEqual(url, URL(string: "https://apps.apple.com/tw/app/blahker-%E5%B7%B4%E6%8B%89%E5%89%8B/id1182699267")!)
                return true
            })
        }

        await store.send(.tapDontTapMeButton) {
            $0.alert = AlertState(
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
        }

        await store.send(.alert(.presented(.rate5Star))) {
            $0.alert = nil
        }
    }

    func testTapRefreshButton_userHaventEnableContentBlocker() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
        }

        await store.send(.tapRefreshButton)
        await store.receive(.userEnableContentBlocker(false)) {
            $0.alert = Self.pleaseEnableContentBlockerAlert
        }
        
        await store.send(.alert(.presented(.okToReloadContentBlocker)))
        
//        await store.send(.alert(.dismiss)){
//            $0.alert = nil
//        }
    }

    func testTapRefreshButton_userAlreadyEnableContentBlocker() async throws {}
}
