//
//  HomeFeature+Extension.swift
//
//
//  Created by John Mai on 2024/1/13.
//

import ComposableArchitecture
import Foundation

extension AlertState<HomeFeature.Action.Alert> {
    static var pleaseEnableContentBlocker: Self {
        AlertState<HomeFeature.Action.Alert>(
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
                ),
            ]
        )
    }
    
    static var updateSuccess: Self {
        AlertState<HomeFeature.Action.Alert>(
            title: TextState("更新成功"),
            message: TextState("已下载最新挡广告网站清单"),
            buttons: [
                ButtonState(
                    role: .cancel,
                    label: {
                        TextState("确定")
                    }
                )
            ]
        )
    }
}
