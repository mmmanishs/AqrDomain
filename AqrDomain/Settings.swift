//
//  Settings.swift
//  AqrDomain
//
//  Created by Singh,Manish on 12/21/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import UIKit

class Settings: NSObject {
    var useNetwork = true
    var localDataPath = ""
    init(plistName:String?) {
        super.init()
        guard let dictionary = self.getPlistDictionaryForName(plistName: plistName) else {
            return
        }
        
        self.useNetwork = dictionary.object(forKey: "UseNetwork") as! Bool
        self.localDataPath = dictionary.object(forKey: "LocalDataPath") as! String
    }
    func getPlistDictionaryForName(plistName:String?) -> NSDictionary? {
        guard let plistName = plistName else {
            return nil
        }
        if let path = Bundle.main.path(forResource: plistName, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }
}
