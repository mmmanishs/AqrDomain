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
    
    func saveDataToLocal(_ data:Data?) {
        guard let data = data else {
            return
        }
        do {
            try data.write(to: URL(fileURLWithPath: getLocalDataFilePath()), options: .atomicWrite)
        }
        catch {
            print("Exception when writing to the file")
        }
        
    }
    func getSearchDataFromLocal() -> AnyObject? {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: getLocalDataFilePath())) {
            do {
                let dictData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    return dictData as AnyObject?
            }
            catch {
                print("Cannot read search data")
            }
        }
        
        return nil
    }
    
    func getLocalDataFilePath() -> String {
        return AppManager.sharedInstance.appSettings.localDataPath
    }
}
