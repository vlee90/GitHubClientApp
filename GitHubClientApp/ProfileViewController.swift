//
//  ProfileViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/24/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var publicLabel: UILabel!
    @IBOutlet weak var hireable: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.networkController?.getAuthUser({ (error, data) -> Void in
            let urlString = data["avatar_url"] as String
            let url = NSURL(string: urlString)
            self.networkController?.createUIImage(url!, completionHanlder: { (imageToPass) -> Void in
                self.imageView.image = imageToPass
            })
            self.nameLabel.text = data["name"] as? String
            self.userNameLabel.text = data["login"] as? String
            let privateNumber = data["owned_private_repos"] as Int
            let publicNumber = data["public_repos"] as Int
            self.privateLabel.text = "Private Repos: \(privateNumber)"
            self.publicLabel.text = "Public Repos: \(publicNumber)"
            let hireStatus = data["hireable"] as Bool
            if hireStatus == true {
                self.hireable.text = "Hireable: Yes"
            }
            else {
                self.hireable.text = "Hireable: No"
            }
            self.bioLabel.text = data["bio"] as? String
            
        })
        
    }
    
}
