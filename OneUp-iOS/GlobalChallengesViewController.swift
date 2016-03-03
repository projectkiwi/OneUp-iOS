//
//  GlobalChallengesViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 2/25/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class GlobalChallengesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var challenges = [Challenge]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        tableViewSetup()
    }
    
    func getData() {
        ApiClient.getChallenges(nil) { (challenges, error) -> () in
            // success
            if error == nil {
                self.challenges = challenges!
                self.tableView.reloadData()
            }
            
            // error
            else {
                
            }
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162 // "average" cell height
        
        let cellNib = UINib(nibName: "FeedTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
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


extension GlobalChallengesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedTableViewCell.cellIdentifier, forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.challenge = challenges[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 162
    }
}

extension GlobalChallengesViewController: UITableViewDelegate {
    
}