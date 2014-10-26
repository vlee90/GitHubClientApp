//
//  UserDetailViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/22/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var networkController: NetworkController?
    var userName: String?
    var repoData = []
    let nibCellName = "UserRepoCell"
    let reuseIdentifier = "USER_REPO_CELL"
    
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.tableView.registerNib(UINib(nibName: self.nibCellName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: self.reuseIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.networkController?.getUser(self.userName!, completionFunction: { (error, data) -> Void in
            let dictionary = data
            let profileURlString = dictionary["avatar_url"] as? String
            let profileURL = NSURL(string: profileURlString!)
            self.networkController?.createUIImage(profileURL!, completionHanlder: { (imageToPass) -> Void in
                self.imageView.image = imageToPass
            })
            self.userNameLabel.text = dictionary["login"] as? String
            self.emailLabel.text = dictionary["email"] as? String
            self.nameLabel.text = dictionary["name"] as? String
            self.companyLabel.text = dictionary["company"] as? String
            self.locationLabel.text = dictionary["location"] as? String
            let followers = dictionary["followers"] as? Int
            let following = dictionary["following"] as? Int
            self.followersLabel.text = "Followers: \(followers!)"
            self.followingLabel.text = "Following: \(following!)"
            self.bioLabel.text = dictionary["bio"] as? String
        })
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as UserRepoCell
        self.networkController?.getUserRepo(self.userName!, completionFunction: { (error, data) -> Void in
            println(data)
//            self.repoData = data
//            cell.repoNameLabel.text = self.repoData![indexPath.row]!["name"] as? String
        })
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("HI")
        return self.repoData.count
    }
}
