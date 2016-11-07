//
//  Suggestion.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/6/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation

class SearchSuggestion: NSObject {
    var domain:String?
    var host:String?
    var path:String?
    var registerURL:String?
    var subdomain:String?
    var domainZone:String?
    required init(dictionary:NSDictionary?) {
        guard let dictionary = dictionary else {
            return
        }
        self.domain = dictionary["domain"] as? String
        self.host = dictionary["host"] as? String
        self.path = dictionary["path"] as? String
        self.registerURL = dictionary["registerURL"] as? String
        self.subdomain = dictionary["subdomain"] as? String
        self.domainZone = dictionary["zone"] as? String
        print(domain)
    }
}

// Do any additional setup after loading the view, typically from a nib.
/*
 APIManager.sharedInstance.searchDomainName(query: "abc",completion: {
 (success, dataReceived) in
 print("Data Received")
 })
 */
