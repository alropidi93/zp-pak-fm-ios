//
//  NotificationCenterExtension.swift
//  pak-ios
//
//  Created by Paolo Rossi on 5/15/18.
//  Copyright © 2018 Paolo Rossi. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let viewInit = Notification.Name(
        rawValue: "to_initial")
    
    static let viewStore = Notification.Name(
        rawValue: "to_store")
}
