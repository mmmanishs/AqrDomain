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
    
    func parseSearchSuggestionJson(_ json:AnyObject?) -> [SearchSuggestion]? {
        if let resultDict  = json as? NSDictionary {
            if let resultArray = resultDict["results"] as? [NSDictionary] {
                var extractedSearchResults = [SearchSuggestion]()
                for dict in resultArray {
                    let searchResult = SearchSuggestion(dictionary: dict)
                    extractedSearchResults.append(searchResult)
                }
                return extractedSearchResults
            }
        }
        return nil
    }
}
