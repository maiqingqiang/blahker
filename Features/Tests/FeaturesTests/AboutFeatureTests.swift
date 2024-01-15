//
//  AboutFeatureTests.swift
//
//
//  Created by John Mai on 2024/1/15.
//

import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class AboutFeatureTests: XCTestCase {
    func testTapReportCell_checkCanSendMail_disabled_presentAlert() async throws {
        let store = TestStore(
            initialState: AboutFeature.State(),
            reducer: {
                AboutFeature()
            }
        ) {
            $0.mailComposeClient.canSendMail = { false }
        }

        await store.send(.tapReportCell)
        await store.receive(.presentPleaseEnableiOSMailAlert) {
            $0.alert = .pleaseEnableiOSMail
        }
    }

    func testTapReportCell_checkCanSendMail_enabled_presentAlert() async throws {
        let store = TestStore(
            initialState: AboutFeature.State(),
            reducer: {
                AboutFeature()
            }
        ) {
            $0.mailComposeClient.canSendMail = { true }
        }

        await store.send(.tapReportCell)
    }
}
