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
    
    var challenge: Challenge! {
        didSet {
            challengeTitleLabel.text = challenge.name
            challengeHeartCountLabel.text = "\(challenge.votes)"
            challengeDescriptionLabel.text = challenge.desc
            challengeAuthorLabel.text = challenge.username
            
            if let cachedGIF = challenge.cachedGIFImage {
                self.mainImageView.image = cachedGIF
            } else {
                fetchGIF({ (image) in
                    self.mainImageView.image = image
                })
            }
            
//            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//            dispatch_async(queue) {
//                self.mainImageView.image = UIImage.gifWithURL("\(self.challenge.previewGif)")
//            }
            
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
    
    func fetchGIF(completion: (image: UIImage) -> ()) {
        
//        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        dispatch_async(queue) {
//            let gif = UIImage.gifWithURL("\(self.challenge.previewGif)")
//            completion(image: gif!)
//        }
        
        
        let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        dispatch_async(backgroundQueue, {
            let gif = UIImage.gifWithURL("\(self.challenge.previewGif)")
            self.challenge.cachedGIFImage = gif!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(image: gif!)
            })
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
