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
    @IBOutlet weak var heartButton: UIButton!
    
    var attempt: Attempt? {
        didSet {
            authorLabel.text = attempt!.author
//            scoreLabel.text = "\(attempt!.votes) likes"
            scoreLabel.text = attempt?.description
            previewImageView.setImageWithURL(NSURL(string: (attempt?.imgUrl)!)!)
            dateLabel.text = attempt?.timestamp
        }
    }

    @IBAction func onLike(sender: AnyObject) {
        ApiClient.likeChallenge(attempt!.id) { (liked, error) -> () in 
            if error == nil { // success
                if liked {
                    self.heartButton.imageView?.image = UIImage(named: "heart_red")
                } else {
                    self.heartButton.imageView?.image = UIImage(named: "heart")
                }
            }
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
