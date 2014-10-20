//
//  SplitContainerViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //  SplitContainerVC will be delegate of the SplitVC. The delgate determines how to display the master and detail views.
            // Sets splitVC to be the first child of the SplitContainerVC
        let splitVC = self.childViewControllers.first as UISplitViewController
        splitVC.delegate = self
        
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }
    
}
