//
//  AppManager.swift
//  AqrDomain
//
//  Created by Singh,Manish on 12/21/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    static let sharedInstance = AppManager()
    let appSettings = Settings(plistName: "Settings")

}
