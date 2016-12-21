//
//  TSNotificationCenter.swift
//  TSNotificationCenter
//
//  Created by Singh,Manish on 1/13/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//


import UIKit
enum NotificationFireType{
    case notificationFireAndForget
    case notificationFireAndRememberOnceIfNotIntercepted
    case notificationFireAndRememberAlways
}



class TSNotificationCenter: NSObject {

    static let defaultCenter = TSNotificationCenter()
    var listeners:[TSNotificationObserver]?
    var notificationsPosted:[TSNotification]?

    override init() {
        super.init()
    }
    
  //MARK:Use this for posting notification
    func postTSNotificationWithName(_ name:String?, withObject:AnyObject?, notificationFireType:NotificationFireType?){
        //Add object to a queue with name as a identifier for that object

        guard let name = name else{
            return
        }
        
        if notificationsPosted == nil {
            notificationsPosted = [TSNotification]()
        }
        
        let notificationPosterObject = TSNotification(name: name, payload: withObject, notificationFireType: notificationFireType)
        
        //Check and remove other similar objects
        
        if let notificationsPosted = notificationsPosted {
            for (index,obj) in notificationsPosted.enumerated(){
                if obj.name == notificationPosterObject.name{
                    self.notificationsPosted?.remove(at: index)
                }
            }
        }
        
        notificationsPosted?.append(notificationPosterObject)

        self.runTSNotificationDispatcherForPostedNotification(notificationPosterObject)
    }
    
    //MARK:Use this for adding observer for notification
    func addOserverForName(_ name:String, observer:NSObject,selector:Selector){
        if listeners == nil {
            listeners = [TSNotificationObserver]()
        }
        
        //Added to the queue
        let messageObject = TSNotificationObserver(name: name, observer: observer, selector: selector)
        self.listeners?.append(messageObject)
        
        self.runTSNotificationDispatcherForNewObserver(messageObject)
       
    }
    //MARK:Use this for removing observer for notification
    func removeObserver(observer:NSObject, name: String){
        guard let listenersForNotificationName = self.getListenersForNotification(name) else {
            return
        }
        for notificationObserver in listenersForNotificationName {
            if notificationObserver.observer == observer {
                self.listeners?.remove(at: (self.listeners?.index(of: notificationObserver))!)
            }
        }
    }

    //MARK: Use this to find out whether a particuar notification has been posted
    func hasGotListenersForNotificationName(_ name:String) -> Bool {
        return self.listeners?.filter({
            let listener:TSNotificationObserver = $0
            return listener.name == name
        }) != nil
    }
    
    //MARK: Use this to find out whether a particuar notification has been posted
    func hasGotNotificationForName(_ name:String) -> Bool {
        return self.notificationsPosted?.filter({
        let postedNotification:TSNotification = $0
            return postedNotification.name == name
        }) != nil
    }
    //MARK: This for returning all the objects listening to that particuar notification
    func getListenersForNotification(_ name:String) ->[TSNotificationObserver]?{
        
        //Searching for addresssees
        
        return listeners?.filter({
            let obj:TSNotificationObserver = $0
            return obj.name == name
        })
    }
    


}


private extension TSNotificationCenter {
    //MARK: Dispatches messages to objects
    //Here resides all the firing mechanisms
    func runTSNotificationDispatcherForNewObserver(_ newObserver:TSNotificationObserver){
        guard let notificationsPosted = notificationsPosted else{
            return
        }
        for notification in notificationsPosted{
            if notification.name == newObserver.name{
                //Has a notification waiting for it
                if let selector = newObserver.selector {
                    newObserver.observer?.perform(selector, with: notification.payload)
                    notification.wasDispatched()
                    self.handleFutureOfNotification(notification)
                }
                break
            }
        }
    }
    
    func runTSNotificationDispatcherForPostedNotification(_ notification:TSNotification){
        //If some listener was found then remove from the posted notification list
        listeners?.forEach({
            let obj:TSNotificationObserver = $0
            if obj.name == notification.name{
                if let selector = obj.selector {
                    obj.observer?.perform(selector, with: notification.payload)
                    notification.wasDispatched()
                }
            }
        })
        self.handleFutureOfNotification(notification)
    }

    func handleFutureOfNotification(_ notification:TSNotification) {
        if notification.shouldRemoveFromQueue() {
            self.removePostedNotification(notification)
        }
    }
    
    func removePostedNotification(_ notification:TSNotification){
        guard let notificationsPosted = self.notificationsPosted else{
            return
        }
        //Check and remove posted notifications with name
        
        for (index,obj) in notificationsPosted.enumerated(){
            if obj == notification{
                self.notificationsPosted?.remove(at: index)
                break
            }
        }
    }
    
    func removeObserverForName(_ name:String?){
        guard let _ = name,
        let listeners = listeners else{
            return
        }
        
        for (index,obj) in listeners.enumerated(){
            if obj.name == name{
                notificationsPosted?.remove(at: index)
                break
            }
        }
        //Remove the notfication with the name from the present transmitters
    }
}
