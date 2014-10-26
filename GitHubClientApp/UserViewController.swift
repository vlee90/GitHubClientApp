//
//  UserViewController.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/22/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var networkController: NetworkController?
    var userArray = []
    var animationController = AnimationController()
    
    
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
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 5
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var userDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_DETAIL_VC") as UserDetailViewController
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as UserCell
        userDetailVC.userName = cell.userNameLabel.text
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return searchBar.text.validate()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.networkController?.searchUsers(searchBar.text, sort: nil, order: nil, completionFunction: { (error, data) -> Void in
            var itemArray = data["items"] as NSArray
            self.userArray = itemArray
            self.collectionView.reloadData()
            self.searchBar.resignFirstResponder()
        })
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.navigationController?.delegate = nil
        return self.animationController
    }
    
}
