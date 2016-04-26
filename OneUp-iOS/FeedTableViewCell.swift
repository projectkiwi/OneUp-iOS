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
            challengeAuthorLabel.text = challenge.topAttempt?.author
            challengeCategoriesLabel.text = challenge.categoriesString
            challengeTimeLabel.text = challenge.timestamp
            
            if self.challenge.cachedGIFImage != nil {
                self.mainImageView.image = self.challenge.cachedGIFImage
            } else {
                fetchGIF({ () in // Callback, Set Image to Current Challenge (if image exists)
                    if self.challenge.cachedGIFImage != nil {
//                        self.mainImageView.image = self.challenge.cachedGIFImage
                        self.mainImageView.alpha = 0.0
                        self.mainImageView.image = self.challenge.cachedGIFImage
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.mainImageView.alpha = 1.0
                        })
                        
                    }
                })
            }
            
        }
    }
    
    func fetchGIF(completion: () -> ()) {
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        dispatch_async(backgroundQueue, {
            if self.challenge.cachedGIFImage == nil {
                self.challenge.downloadGIF()
            }
            
            if self.challenge.cachedGIFImage != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion()
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
