//
//  UserViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/22/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var networkController: NetworkController?
    var userArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerNib(UINib(nibName: "UserCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "USER_CELL")
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        let avatarURLString = self.userArray[indexPath.row]["avatar_url"] as String
        let avatarURL = NSURL(string: avatarURLString)
        self.networkController?.createUIImage(avatarURL!, completionHanlder: { (imageToPass) -> Void in
            cell.imageView.image = imageToPass
        })
        
        cell.userNameLabel.text = self.userArray[indexPath.row]["login"]! as? String
        cell.userNameLabel.textColor = UIColor.whiteColor()
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.networkController?.searchUsers(searchBar.text, sort: nil, order: nil, completionFunction: { (error, data) -> Void in
            var itemArray = data["items"] as NSArray
            self.userArray = itemArray
            self.collectionView.reloadData()
            self.searchBar.resignFirstResponder()
        })
    }
}
