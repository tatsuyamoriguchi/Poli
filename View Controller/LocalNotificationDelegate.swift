//
//  LocalNotificationDelegate.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/19/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
