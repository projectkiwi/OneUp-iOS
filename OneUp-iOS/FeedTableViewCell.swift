//
//  FeedTableViewCell.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 2/25/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import SwiftGifOrigin

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
    
    var challengeIndex: Int?
    var challenge: Challenge! {
        didSet {
            challengeTitleLabel.text = challenge.name
            challengeHeartCountLabel.text = "\(challenge.votes)"
            challengeDescriptionLabel.text = challenge.desc
            challengeAuthorLabel.text = challenge.username
            
            if let cachedGIF: UIImage = challenge.cachedGIFImage {
                self.mainImageView.image = cachedGIF
            } else {
                fetchGIF({ (image) in
                    self.mainImageView.image = image
                })
            }
            
            var categoriesString = ""
            for category in challenge.categories {
                categoriesString += "\(category), "
            }
            
            if categoriesString.characters.count > 0 {
                categoriesString = categoriesString.substringToIndex(categoriesString.endIndex.predecessor())
                categoriesString = categoriesString.substringToIndex(categoriesString.endIndex.predecessor())
            }
            
            challengeCategoriesLabel.text = categoriesString
            challengeTimeLabel.text = challenge.timestamp
        }
    }
    
    func fetchGIF(completion: (image: UIImage) -> ()) {
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        dispatch_async(backgroundQueue, {
            if let gif = UIImage.gifWithURL(self.challenge.previewGif) {
                // Update Cached GIF
                self.challenge.cachedGIFImage = gif
                if self.challengeIndex != nil {
                    if let challengesVC = self.window?.rootViewController as? ChallengesViewController {
                        challengesVC.challenges[self.challengeIndex!].cachedGIFImage = gif
                    }
                }
                
                // Call Callback
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(image: gif)
                })
            }
        })

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // rounded edges on back
        contentContainerView.layer.cornerRadius = 5
        contentContainerView.clipsToBounds = true
        
        mainImageView.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
