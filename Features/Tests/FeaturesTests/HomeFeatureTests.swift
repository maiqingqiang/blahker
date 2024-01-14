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
    func testAppBecomeActive_userHaventEnableContentBlocker() async throws {
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
            $0.alert = .pleaseEnableContentBlocker
            $0.appLaunchCheck = false
        }
    }

    func testAppLaunch_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(appLaunchCheck: true, isEnabledContentBlocker: false),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in
                do {
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    print(error.localizedDescription)
                }

                return true
            }
        }

        await store.send(.appDidFinishLaunching)
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.appLaunchCheck = false
        }
    }

    func testAppBecomeActive_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(isEnabledContentBlocker: true),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
        }

        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.appLaunchCheck = false
        }
    }

    func testAppBecomeActive_userAlreadyEnableContentBlocker_laterEnabled() async throws {
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
            $0.alert = .pleaseEnableContentBlocker
            $0.appLaunchCheck = false
        }

        store.dependencies.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
        await store.send(.scenePhaseBecomeActive)
        await store.receive(.userEnableContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccess
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
            initialState: HomeFeature.State(appLaunchCheck: false),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in false }
        }

        await store.send(.tapRefreshButton)
        await store.receive(.manuallyCheckUserEnabledContentBlocker(false)) {
            $0.alert = .pleaseEnableContentBlocker
            $0.appLaunchCheck = false
        }

        await store.send(.alert(.presented(.okToReloadContentBlocker))) {
            $0.alert = nil
        }
        await store.receive(.manuallyCheckUserEnabledContentBlocker(false)) {
            $0.alert = .pleaseEnableContentBlocker
        }

        store.dependencies.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }

        await store.send(.alert(.presented(.okToReloadContentBlocker))) {
            $0.alert = nil
        }
        await store.receive(.manuallyCheckUserEnabledContentBlocker(true)) {
            $0.isEnabledContentBlocker = true
            $0.alert = .updateSuccess
        }
    }

    func testTapRefreshButton_userAlreadyEnableContentBlocker() async throws {
        let store = TestStore(
            initialState: HomeFeature.State(appLaunchCheck: false, isEnabledContentBlocker: true),
            reducer: {
                HomeFeature()
            }
        ) {
            $0.contentBlockerService.checkUserEnabledContentBlocker = { _ in true }
        }

        await store.send(.tapRefreshButton)
        await store.receive(.manuallyCheckUserEnabledContentBlocker(true)) {
            $0.alert = .updateSuccess
        }
    }
}
