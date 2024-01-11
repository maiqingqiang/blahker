//
//  SwiftUIView.swift
//
//
//  Created by John Mai on 2024/1/4.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WithViewStore(store, observe: { $0 }) { _ in
            NavigationStack {
                VStack {
                    setupDescription
                    Spacer()
                    dontTapMeButton
                }
                .navigationTitle("Blahker")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        refreshButton
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        aboutButton
                    }
                }
                .onChange(of: scenePhase) { newValue in
                    switch newValue {
                    case .active:
                        store.send(.scenePhaseBecomeActive)
                    case .background, .inactive:
                        break
                    @unknown default:
                        break
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var setupDescription: some View {
        Text("""
        Blahker致力于消除网站中的盖版广告，支持Safari浏览器。
        
        App将会自动取得最新挡广告网站清单，你也可以透过左上角按钮手动更新。
        
        欲回报广告网站或者了解更多信息，请参阅「关于」页面。
        """)
        .padding()
    }
    
    @MainActor
    @ViewBuilder
    private var dontTapMeButton: some View {
        Button(
            action: {
                store.send(.tapDontTapMeButton)
            },
            label: {
                Text("拜托别按我")
            }
        )
        .foregroundColor(.white)
        .font(.title2)
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
    
    @MainActor
    @ViewBuilder
    private var refreshButton: some View {
        Button(
            action: {
                store.send(.tapRefreshButton)
            },
            label: {
                Image(systemName: "arrow.clockwise")
            }
        )
        .buttonStyle(.plain)
    }
    
    @MainActor
    @ViewBuilder
    private var aboutButton: some View {
        Button(
            action: {
                store.send(.tapAboutButton)
            },
            label: {
                Text("关于")
            }
        )
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(store: .init(
        initialState: HomeFeature.State(),
        reducer: {
            HomeFeature()
        }
    ))
}
