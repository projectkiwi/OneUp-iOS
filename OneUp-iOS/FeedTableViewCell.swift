//
//  FeedTableViewCell.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 2/25/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    static let cellIdentifier = "com.purduecs.kiwi.FeedTableViewCell"
    
    @IBOutlet weak var rightContentView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var contentContainerView: UIView!
    
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var challengeTimeLabel: UILabel!
    @IBOutlet weak var challengeAuthorLabel: UILabel!
    @IBOutlet weak var challengeDescriptionLabel: UILabel!
    @IBOutlet weak var challengeHeartCountLabel: UILabel!
    @IBOutlet weak var challengeCategoriesLabel: UILabel!
    
    var challenge: Challenge! {
        didSet {
            challengeTitleLabel.text = challenge.name
            
            var catergoriesString = ""
            for catergory in challenge.categories {
                catergoriesString += "\(catergory), "
            }
            
            if catergoriesString.characters.count > 0 {
                catergoriesString = catergoriesString.substringToIndex(catergoriesString.endIndex.predecessor())
                catergoriesString = catergoriesString.substringToIndex(catergoriesString.endIndex.predecessor())
            }
            
            challengeCategoriesLabel.text = catergoriesString
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // rounded edges on back
        contentContainerView.layer.cornerRadius = 5
        contentContainerView.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
