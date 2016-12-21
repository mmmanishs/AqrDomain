//
//  TSNotificationObserver.swift
//  TSNotificationCenter
//
//  Created by Singh,Manish on 9/20/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation

class TSNotificationObserver:NSObject {
    init(name:String, observer:NSObject, selector:Selector){
        super.init()
        self.observer = observer
        self.selector = selector
        self.name = name
    }
    var observer:NSObject?
    var selector:Selector?
    var name:String?

}
