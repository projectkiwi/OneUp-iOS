//
//  NotificationCell.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/20/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var statusChangeLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var notification: Notification! {
        didSet {
            
            if let url = notification.authorImgUrl {
                profileImageView.setImageWithURL(NSURL(string: url)!)
            } else {
                profileImageView.setImageWithURL(NSURL(string: "https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg")!)
            }
            
            authorLabel.text = notification.author
            statusChangeLabel.text = notification.statusChange
            timestampLabel.text = notification.timeStamp
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // rounded edges on profile image
        profileImageView.layer.cornerRadius = 29
        profileImageView.clipsToBounds = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
