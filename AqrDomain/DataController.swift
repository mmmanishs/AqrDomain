//
//  DataController.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/6/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation

class DataController: NSObject {
    static let sharedInstance = DataController()
    var searchResults = [SearchSuggestion]()
}