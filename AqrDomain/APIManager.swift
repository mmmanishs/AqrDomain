//
//  APIManager.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/6/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation
class APIManager: NSObject {
    static let sharedInstance = APIManager()
    
    let shouldLoadFromLocal = true
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var currentTask:NSURLSessionTask?
    
    func searchDomainName(query query:String,completion: ((success:Bool, dataReceived :[SearchSuggestion]?)->Void))  {
        if shouldLoadFromLocal == true {
            completion(success:true, dataReceived: DataController.sharedInstance.parseSearchSuggestionJson(LocalDataManager.sharedInstance.getSearchDataFromLocal()))
            return
        }
        if currentTask != nil {
            currentTask?.cancel()
        }
        let urlString = "https://domainr.p.mashape.com/v2/search?mashape-key=&defaults=club%2Ccoffee&location=de&query="+query+"&registrar=namecheap.com"
        let encodedUrlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())
        guard let url = NSURL(string: encodedUrlString!) else{
            print("Cannot make a url out of it.")
            return
        }
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        request.setValue("czbdyylahJmsh86PI5jfI8VS7yjUp1eP9B8jsn4eRqCz33C2Nj", forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
         let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else{
                return
            }
            LocalDataManager.sharedInstance.saveDataToLocal(data)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves)
                completion(success:true, dataReceived: DataController.sharedInstance.parseSearchSuggestionJson(json))
            }
            catch {
                print("Unable to convert data to json")
            }
        })
        task.resume()
        currentTask = task
    }
    

}