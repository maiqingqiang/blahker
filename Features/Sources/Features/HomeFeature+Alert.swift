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
        Self(
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
        Self(
            title: TextState("更新成功"),
            message: TextState("已下载最新挡广告网站清单"),
            buttons: [
                ButtonState(
                    role: .cancel,
                    label: {
                        TextState("确定")
                    }
                ),
            ]
        )
    }

    static var donation: Self {
        Self(
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
}
