//
//  UserRepoCell.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/22/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class UserRepoCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var watch: UILabel!
    @IBOutlet weak var star: UILabel!
    @IBOutlet weak var fork: UILabel!
    

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
