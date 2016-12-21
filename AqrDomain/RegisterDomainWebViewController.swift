//
//  RegisterDomainWebViewController.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/8/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import UIKit

class RegisterDomainWebViewController: UIViewController {

    @IBOutlet var webview: UIWebView!
    var urlStringToLoad:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = self.urlStringToLoad {
            if let url = URL(string: urlString) {
                let request = URLRequest(url:url)
                self.webview.loadRequest(request)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
