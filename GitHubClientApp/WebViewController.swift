//
//  WebViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/24/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView = WKWebView()
    var urlString: String?
    
    override func loadView() {
        super.loadView()
//        self.webView = WKWebView()
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: urlString!)
        self.webView.loadRequest(NSURLRequest(URL: url!))
    }

}
