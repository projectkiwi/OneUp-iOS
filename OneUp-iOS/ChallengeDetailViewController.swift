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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add custom cell
        let cellNib = UINib(nibName: "AttemptTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: AttemptTableViewCell.cellIdentifier)
        
        tableView.rowHeight = 126
        
        tableView.delegate = self
        tableView.dataSource = self
        

        likesView.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ChallengeDetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AttemptTableViewCell.cellIdentifier, forIndexPath: indexPath) as! AttemptTableViewCell
        
//        switch (indexPath.row) {
//        case 0:
//            cell.attemptAuthorLabel.textColor = UIColor.oneUp_goldColor()
//            break
//            
//        case 1:
//            cell.attemptAuthorLabel.textColor = UIColor.oneUp_silverColor()
//            break
//            
//        default: break
//            
//            
//        }
        
        
        return cell
    }


}


extension ChallengeDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
}
