//
//  AttemptTableViewCell.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/27/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class AttemptTableViewCell: UITableViewCell {

    static let cellIdentifier = "AttemptCell"

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    var attempt: Attempt? {
        didSet {
            authorLabel.text = attempt!.author
//            scoreLabel.text = "\(attempt!.votes) likes"
            scoreLabel.text = attempt?.description
            previewImageView.setImageWithURL(NSURL(string: (attempt?.imgUrl)!)!)
            dateLabel.text = attempt?.timestamp
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
