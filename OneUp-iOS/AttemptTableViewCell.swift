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
            // TODO: Edit this value so it shows the right info
            scoreLabel.text = "\(attempt?.votes) people"
            previewImageView.setImageWithURL(NSURL(string: (attempt?.imgUrl)!)!)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//         scoreLabel.text = "\(attempt?.votes) people"
        
//        previewImageView.setImageWithURL(NSURL(string: (attempt?.imgUrl!)!)!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
