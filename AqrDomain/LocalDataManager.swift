//
//  LocalDataManager.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/7/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation
class LocalDataManager: NSObject {
    static let sharedInstance = LocalDataManager()
    func saveDataToLocal(data:NSData?) {
        guard let data = data else {
            return
        }
        do {
            try data.writeToFile(getLocalDataFilePath(), options: .AtomicWrite)
        }
        catch {
            print("Exception when writing to the file")
        }
        
    }
    func getSearchDataFromLocal() -> AnyObject? {
        if let data = NSData(contentsOfFile: getLocalDataFilePath()) {
            do {
                let dictData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves)
                    return dictData
            }
            catch {
                print("Cannot read search data")
            }
        }
        
        return nil
    }
    
    func getLocalDataFilePath() -> String {
        return "/Users/ldq847/MyFolders/Code Source/AqrDomain/AqrDomain/LocalData"
    }
}