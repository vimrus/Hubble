//
//  Notification.swift
//  Hubble
//
//  Created by vimrus on 2017/10/1.
//  Copyright © 2017年 Hubble. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let refresh = Notification.Name("refresh")
    static let login = Notification.Name("login")
    static let logout = Notification.Name("logout")
    static let updatePlugins = Notification.Name("updatePlugins")
    static let profileSynced = Notification.Name("profileSynced")
    static let post = Notification.Name("post")
    static let reply = Notification.Name("reply")
    static let browse = Notification.Name("browse")
    static let fontScale = Notification.Name("fontScale")
}

extension NotificationCenter {
    static func post(name: NSNotification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
}
