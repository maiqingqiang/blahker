//
//  ContentBlockerService.swift
//  Blahker
//
//  Created by John Mai on 2024/1/3.
//

import Dependencies
import DependenciesMacros
import Foundation
import SafariServices

@DependencyClient
public struct ContentBlockerService {
    public var checkUserEnabledContentBlocker: (String) async -> Bool = { _ in
        unimplemented("checkUserEnabledContentBlocker", placeholder: false)
    }

    public var reloadContentBlocker: (String) async throws -> Void
}

extension ContentBlockerService: DependencyKey {
    public static var liveValue = ContentBlockerService(
        checkUserEnabledContentBlocker: { bundleID in
            try? await Task.sleep(for: .seconds(3))

            return await withCheckedContinuation { continuation in
                SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID) { state, error in

                    if let error {
                        print("getStateOfContentBlocker error: \(error.localizedDescription) bundleID: \(bundleID)")
                    }

                    if let state {
                        continuation.resume(returning: state.isEnabled)
                    } else {
                        continuation.resume(returning: false)
                    }
                }
            }
        }, reloadContentBlocker: { bundleID in
            try await withCheckedThrowingContinuation { continuation in
                SFContentBlockerManager.reloadContentBlocker(withIdentifier: bundleID, completionHandler: { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume()
                    }
                })
            }
        }
    )
}

public extension DependencyValues {
    var contentBlockerService: ContentBlockerService {
        get { self[ContentBlockerService.self] }
        set { self[ContentBlockerService.self] = newValue }
    }
}
