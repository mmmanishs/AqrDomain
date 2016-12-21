//
//  TSNotification.swift
//  TSNotificationCenter
//
//  Created by Singh,Manish on 9/20/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation
class TSNotification:NSObject {
    init(name:String,payload:AnyObject?,notificationFireType:NotificationFireType?){
        super.init()
        self.name = name
        self.payload = payload
        if let notificationFireType = notificationFireType {
            self.notificationFireType = notificationFireType
        }
        
    }
    var name:String?
    var payload:AnyObject?
    var notificationFireType:NotificationFireType = NotificationFireType.notificationFireAndForget
    var numberOfTimesDispatched:Int = 0
    
    func wasDispatched()  {
        numberOfTimesDispatched = numberOfTimesDispatched + 1
    }
    func shouldRemoveFromQueue() -> Bool {
        switch self.notificationFireType {
        case .notificationFireAndForget:
            return true
        case .notificationFireAndRememberOnceIfNotIntercepted:
            if self.numberOfTimesDispatched >= 1 {
                return true
            }
            else {
                return false
            }
        case .notificationFireAndRememberAlways:
            return false
        }
    }
}
