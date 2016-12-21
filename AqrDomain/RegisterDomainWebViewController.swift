//
//  RegisterDomainWebViewController.swift
//  AqrDomain
//
//  Created by Singh,Manish on 11/8/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import UIKit

class RegisterDomainWebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TSNotificationCenter.defaultCenter.addOserverForName("registerParam", observer: self, selector: #selector(RegisterDomainWebViewController.notificationReceiver(object:)))
    }
    func notificationReceiver(object:AnyObject) {
        guard let urlString = object as? String else {
            print("The type of the payload is wrong")
            return
        }
        if let url = URL(string: urlString) {
            let request = URLRequest(url:url)
            self.webview.loadRequest(request)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingToParentViewController {
            self.navigationController?.navigationBar.isHidden = true
        }
        TSNotificationCenter.defaultCenter.removeObserver(observer: self, name: "registerParam")

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- UIWebview Delegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activityIndicator.isHidden = false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityIndicator.isHidden = true
    }
    @IBAction func buttonCloseClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
