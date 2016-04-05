//
//  ChallengeDetailViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 3/27/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class ChallengeDetailViewController: UIViewController {

    @IBOutlet weak var attemptAuthorLabel: UILabel!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var likesView: UIView!
    @IBOutlet weak var attemptImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var challenge: Challenge!
    var currentAttempt: Attempt? {
        didSet {
            attemptAuthorLabel.text = "Author!"
            likesLabel.text = "\(currentAttempt?.votes)"
            attemptImageView.setImageWithURL(NSURL(string: (currentAttempt?.imgUrl)!)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(challenge.attempts.count <= 0) { // If Challenge has no Attempts, go back
            navigationController?.popViewControllerAnimated(true)
            return;
        }
        currentAttempt = challenge.attempts[0]
        
        setupCustomCell()
        updateUIFields()
        makeLikeButtonInteractive()
        
        // Setup AttemptCreation Data
        AttemptCreationViewController.challengeID = challenge.id
        AttemptCreationViewController.challengeName = challenge.name
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
        challengeNameLabel.text = challenge.name
        attemptAuthorLabel.text = "Author Name"
        //attemptImageView.image = UIImage(contentsOfFile: <#T##String#>)
    }
    
    func makeLikeButtonInteractive() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ChallengeDetailViewController.likeClicked(_:)))
        likesView.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func likeClicked(sender: AnyObject) {
        ApiClient.likeChallenge((challenge.attempts.last?.id)!) { (liked, error) -> () in // TODO: Get correct attemptID
            // success
            if error == nil {
            }
            // error
            else {
                
            }
        }
        likesView.backgroundColor = UIColor.redColor()
    }

}


extension ChallengeDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenge.attempts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AttemptTableViewCell.cellIdentifier, forIndexPath: indexPath) as! AttemptTableViewCell
        
        cell.attempt = challenge.attempts[indexPath.row]
        
        return cell
    }

}


extension ChallengeDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentAttempt = challenge.attempts[indexPath.row]
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
}
