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
    
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var currentTask:NSURLSessionTask?
    
    func searchDomainName(query query:String,completion: ((success:Bool, dataReceived :[SearchSuggestion]?)->Void))  {
        
        if currentTask != nil {
            currentTask?.cancel()
        }
//        NSDictionary *headers = @{@"X-Mashape-Key": @"czbdyylahJmsh86PI5jfI8VS7yjUp1eP9B8jsn4eRqCz33C2Nj"};
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
            let string = String(data: data, encoding: NSUTF8StringEncoding)

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves)

                if let resultDict  = json as? NSDictionary {
                    if let resultArray = resultDict["results"] as? [NSDictionary] {
                        for dict in resultArray {
                            let searchResult = SearchSuggestion(dictionary: dict)
                            DataController.sharedInstance.searchResults.append(searchResult)
                        }
                        completion(success:true, dataReceived: DataController.sharedInstance.searchResults)
                    }
                }
                
            }
            catch {
                print("Unable to convert data to json")
            }
        })
        task.resume()
        currentTask = task
    }
}