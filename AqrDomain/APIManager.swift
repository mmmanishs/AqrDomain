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
        
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var currentTask:URLSessionTask?
    
    func searchDomainName(query:String,completion: @escaping ((_ success:Bool, _ dataReceived :[SearchSuggestion]?)->Void))  {
        if AppManager.sharedInstance.appSettings.useNetwork == true {
            completion(true, DataController.sharedInstance.parseSearchSuggestionJson(LocalDataManager.sharedInstance.getSearchDataFromLocal()))
            return
        }
        if currentTask != nil {
            currentTask?.cancel()
        }
        let urlString = "https://domainr.p.mashape.com/v2/search?mashape-key=&query="+query
        let encodedUrlString = urlString.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: encodedUrlString!) else{
            print("Cannot make a url out of it.")
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("czbdyylahJmsh86PI5jfI8VS7yjUp1eP9B8jsn4eRqCz33C2Nj", forHTTPHeaderField: "X-Mashape-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
         let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else{
                completion(false, nil)

                return
            }
            LocalDataManager.sharedInstance.saveDataToLocal(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                completion(true, DataController.sharedInstance.parseSearchSuggestionJson(json as AnyObject?))
            }
            catch {
                print("Unable to convert data to json")
            }
        })
        task.resume()
        currentTask = task
    }
    

}
