//
//  RepositoryViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var networkController: NetworkController?
    
    let reuseIdentifier = "REPOSITORY_CELL"
    let nibCellName = "RepositoryCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: self.nibCellName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: self.reuseIdentifier)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as RepositoryCell
        self.networkController!.requestData({ (error, data) -> Void in
            let itemArray = data["items"] as NSArray
            let itemDictionary = itemArray[0] as NSDictionary
            let ownerDictionary = itemDictionary["owner"] as NSDictionary
            
            let profileImageString = ownerDictionary["avatar_url"] as String
            let profileImageURL = NSURL(string: profileImageString)
            self.networkController?.createUIImage(profileImageURL!, completionHanlder: { (dataToPass) -> Void in
                let image = UIImage(data: dataToPass!)
                cell.imageViewProfile.image = image
            })
            println(itemDictionary["stargazers_count"]!)
            cell.repoNameLabel.text = itemDictionary["full_name"] as? String
            cell.starLabel.text = itemDictionary["stargazers_count"]! as? String
            cell.watchLabel.text = itemDictionary["watchers_count"]! as? String
            cell.forkLabel.text = itemDictionary["forks_count"]! as? String
        })
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
