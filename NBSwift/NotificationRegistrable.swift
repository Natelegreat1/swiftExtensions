//
//  NotificationRegistrable.swift
//  msg
//
//  Created by Nathaniel Blumer on 2016-11-02.
//  Copyright © 2016 Wherecloud Inc. All rights reserved.
//

import UIKit
import UserNotifications

protocol NotificationRegistrable {
    func registerForNotifications()
}

extension NotificationRegistrable {
    func registerForNotifications() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted == true {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    NSLog("Error: \(error?.localizedDescription)")
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

}
