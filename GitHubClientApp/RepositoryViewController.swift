//
//  RepositoryViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var networkController: NetworkController?
    var repoData: NSArray = []
    
    let reuseIdentifier = "REPOSITORY_CELL"
    let nibCellName = "RepositoryCell"

    var repoURLString = [String]()
    

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
        var ownerDictionary = self.repoData[indexPath.row]["owner"] as? NSDictionary
        let fork = self.repoData[indexPath.row]["forks_count"] as? Int
        let star = self.repoData[indexPath.row]["watchers_count"] as? Int
        let watch = self.repoData[indexPath.row]["stargazers_count"] as? Int
        
        let avatarURLString = ownerDictionary!["avatar_url"] as String
        let avatarURL = NSURL(string: avatarURLString)
        self.networkController?.createUIImage(avatarURL!, completionHanlder: { (imageToPass) -> Void in
            cell.imageViewProfile.image = imageToPass
        })
        self.repoURLString.append(self.repoData[indexPath.row]["html_url"] as String)
        cell.repoNameLabel.text = self.repoData[indexPath.row]["name"]! as? String
        cell.nameLabel.text = ownerDictionary!["login"] as? String
        cell.forkLabel.text = "Forks: \(fork!)"
        cell.watchLabel.text = "Watches: \(watch!)"
        cell.starLabel.text = "Stars: \(star!)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let toVC = self.storyboard?.instantiateViewControllerWithIdentifier("WEB_VIEW") as WebViewController
        toVC.urlString = self.repoURLString[indexPath.row]
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoData.count
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return searchBar.text.validate()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.networkController?.searchRepo(searchBar.text, sort: nil, order: nil, completionFunction: { (error, data) -> Void in
            let searchResultDictionary = data
            let itemArray = searchResultDictionary["items"] as NSArray
            self.repoData = itemArray
            self.tableView.reloadData()
            self.searchBar.resignFirstResponder()
        })
    }
}