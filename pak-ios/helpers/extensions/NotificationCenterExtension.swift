//
//  NotificationCenterExtension.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/15/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let viewInit = Notification.Name(rawValue: "to_initial")    
    static let viewStore = Notification.Name(rawValue: "to_store")
    static let viewNotification = Notification.Name(rawValue: "to_notification")
    static let viewLogueout = Notification.Name(rawValue: "to_viewLogueout")
    static let viewNotificationOut = Notification.Name(rawValue: "to_notificationOut")
    //amd
    static let viewProximo = Notification.Name(rawValue: "to_proximo")
}

