//
//  FeedTableView.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/4/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

protocol FeedTableViewDelegate {
    func feedTableView(controllerToSwitch: ChallengeDetailViewController)
}

protocol FeedTableViewDataSource {
    func feedTableViewChallenges() -> [Challenge]
}

class FeedTableView: UITableView {

    var challenges = [Challenge]()
    var filterItems = [String: Bool]()
    var originalChallenges = [Challenge]() // REMOVE AFTER PAGING IMPLEMENTED: dummy data till backend develops paging
    var isMoreDataLoading = false // used for infinate scroll

    var feedTableViewDelegate: FeedTableViewDelegate?
    var feedTableViewDataSource: FeedTableViewDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        feedTableViewDataSource?.feedTableViewChallenges()
        
        self.delegate = self
        self.dataSource = self
        
        separatorStyle = UITableViewCellSeparatorStyle.None
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 162 // "average" cell height
        
        // add custom cell
        let cellNib = UINib(nibName: "FeedTableViewCell", bundle: NSBundle.mainBundle())
        registerNib(cellNib, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedTableView.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        insertSubview(refreshControl, atIndex: 0)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        feedTableViewDataSource?.feedTableViewChallenges()
        reloadData()
        refreshControl.endRefreshing()
    }

}


// data source
extension FeedTableView: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeedTableViewCell.cellIdentifier, forIndexPath: indexPath) as! FeedTableViewCell
        
        cell.challenge = challenges[indexPath.row]
        cell.challengeIndex = indexPath.row
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 162
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Challenge", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Challenge") as! ChallengeDetailViewController
        ChallengeDetailViewController.challenge = challenges[indexPath.row]
        
        feedTableViewDelegate?.feedTableView(controller)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// delegate
extension FeedTableView: UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - bounds.size.height
            
            // when the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && dragging) {
                isMoreDataLoading = true
                
                // TODO: REMOVE AND IMPLEMENT PAGING WHEN BACKEND READY
//                challenges.appendContentsOf(originalChallenges)
                
//                reloadData()
//                isMoreDataLoading = false
            }
        }
    }
}