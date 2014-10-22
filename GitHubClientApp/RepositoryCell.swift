//
//  RepositoryTableViewCell.swift
//  GitHubClientApp
//
//  Created by Vincent Lee on 10/20/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var watchLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak  var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
