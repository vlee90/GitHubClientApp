//
//  ViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var networkController: NetworkController!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.networkController.requestOAuthAcessGET(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
