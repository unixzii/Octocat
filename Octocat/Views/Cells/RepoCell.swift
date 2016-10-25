//
//  RepoCell.swift
//  Octocat
//
//  Created by 杨弘宇 on 2016/10/23.
//  Copyright © 2016年 杨弘宇. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var langImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
