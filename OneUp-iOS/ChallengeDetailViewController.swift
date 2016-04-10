//
//  ChallengeDetailViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/27/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: UIViewController {
    
    static var challenge: Challenge!

    @IBOutlet weak var attemptAuthorLabel: UILabel!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var bookmarksView: UIView!
    @IBOutlet weak var attemptImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentAttempt: Attempt? {
        didSet {
            attemptAuthorLabel.text = "Author!"
            //likesLabel.text = "\(currentAttempt?.votes)"
            likesLabel.text = "0"
//            attemptImageView.setImageWithURL(NSURL(string: (currentAttempt?.imgUrl)!)!)
            attemptImageView.image = UIImage.gifWithURL("\(ApiClient.apiURL)/\(currentAttempt!.imgUrl!)")
            // http://a4.files.theultralinx.com/image/upload/MTI5MDU2ODQxNjEwMDc0NTkw.gif")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(ChallengeDetailViewController.challenge.attempts.count <= 0) { // If Challenge has no Attempts, go back
            navigationController?.popViewControllerAnimated(true)
            return;
        }
        currentAttempt = ChallengeDetailViewController.challenge.attempts[0]
        
        setupCustomCell()
        updateUIFields()
        makeLikeBookmarkButtonsInteractive()
    }
    
    func setupCustomCell() {
        let cellNib = UINib(nibName: "AttemptTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: AttemptTableViewCell.cellIdentifier)
        
        tableView.rowHeight = 126
        
        tableView.delegate = self
        tableView.dataSource = self
        
        likesView.layer.cornerRadius = 3
    }
    
    func updateUIFields() {
        challengeNameLabel.text = ChallengeDetailViewController.challenge.name
        attemptAuthorLabel.text = "Author Name"
        //attemptImageView.image = UIImage(contentsOfFile: <#T##String#>)
    }
    
    func makeLikeBookmarkButtonsInteractive() {
        // Like Button
        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(ChallengeDetailViewController.likeClicked(_:)))
        likesView.addGestureRecognizer(likeGesture)
        
        // Bookmark Button
        let bookmarkGesture = UITapGestureRecognizer(target: self, action: #selector(ChallengeDetailViewController.bookmarkClicked(_:)))
        bookmarksView.addGestureRecognizer(bookmarkGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func likeClicked(sender: AnyObject) {
        
        // TODO: Immediately Toggle Color
        
        ApiClient.likeChallenge((ChallengeDetailViewController.challenge.attempts.last?.id)!) { (liked, error) -> () in // TODO: Get correct attemptID
            if error == nil { // success
                if liked {
                    self.likesView.backgroundColor = UIColor.redColor()
                } else {
                    self.likesView.backgroundColor = UIColor.greenColor()
                }
            }
        }
    }
    
    @IBAction func bookmarkClicked(sender: AnyObject) {
        
        // TODO: Immediately Toggle Color
        
        ApiClient.bookmarkChallenge((ChallengeDetailViewController.challenge.attempts.last?.id)!) { (bookmarked, error) -> () in
            if error == nil { // success
                if bookmarked {
                    self.bookmarksView.backgroundColor = UIColor.redColor()
                } else {
                    self.bookmarksView.backgroundColor = UIColor.greenColor()
                }
            }
        }
    }

}


extension ChallengeDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChallengeDetailViewController.challenge.attempts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AttemptTableViewCell.cellIdentifier, forIndexPath: indexPath) as! AttemptTableViewCell
        
        cell.attempt = ChallengeDetailViewController.challenge.attempts[indexPath.row]
        
        return cell
    }

}


extension ChallengeDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentAttempt = ChallengeDetailViewController.challenge.attempts[indexPath.row]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
}
