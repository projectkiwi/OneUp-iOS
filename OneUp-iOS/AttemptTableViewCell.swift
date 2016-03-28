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
    
    @IBOutlet weak var attemptAuthorLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func initSubviews() {
        // standard initialization logic
//        let nib = UINib(nibName: "AttemptTableViewCell", bundle: nil)
//        nib.instantiateWithOwner(self, options: nil)
//        contentView.frame = bounds
//        addSubview(contentView)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
