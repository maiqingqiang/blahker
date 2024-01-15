//
//  AboutFeature+Alert.swift
//
//
//  Created by John Mai on 2024/1/15.
//

import ComposableArchitecture
import Foundation

extension AlertState<AboutFeature.Action.Alert> {
    static var pleaseEnableiOSMail: Self {
        Self(
            title: TextState("请先启用 iOS 邮件"),
            message: TextState("请先至iOS邮件app登入邮箱，或寄信到elaborapp+blahker@gmail.com"),
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
