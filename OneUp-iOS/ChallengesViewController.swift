//
//  ChallengesViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 2/25/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import XMSegmentedControl

class ChallengesViewController: UIViewController, XMSegmentedControlDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    enum DataSources {
        case Local
        case Popular
        case Global
    }
    
    var currentDataSource:DataSources = .Local
    var challenges = [Challenge]()
    static var filterItems: [String: Bool] = ["sports": true, "Drinks": false, "Food": false]
    var originalChallenges = [Challenge]() // REMOVE AFTER PAGING IMPLEMENTED: dummy data till backend develops paging
    var isMoreDataLoading = false // used for infinate scroll

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDataSource = .Local
        setupSegmentedControl()
        loadTableAndData()
        tableViewSetup()
        
        self.navigationController?.tabBarItem!.image = UIImage(named: "home") // Set Tab Bar Icon
    }
    
    // XMSegmentedControl
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        if(selectedSegment == 0) {
            currentDataSource = .Local
        }
        if(selectedSegment == 1) {
            currentDataSource = .Popular
        }
        if(selectedSegment == 2) {
            currentDataSource = .Global
        }
        loadTableAndData(); // Reload Table
    }
    
    func setupSegmentedControl() {
        let segmentedControl = XMSegmentedControl(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 44), segmentTitle: ["Local", "Popular", "Global"], selectedItemHighlightStyle: XMSelectedItemHighlightStyle.BottomEdge)
        
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor(red: 115/255, green: 44/255, blue: 123/255, alpha: 1)
        segmentedControl.highlightColor = UIColor(red: 165/255, green: 66/255, blue: 220/255, alpha: 1)
        segmentedControl.tint = UIColor.whiteColor()
        segmentedControl.highlightTint = UIColor.lightGrayColor()
        
        self.view.addSubview(segmentedControl)
    }
    
    
    
    // Challenges Table
    func loadTableAndData() {
        // TODO: Apply Filters
        var requestURL = "/challenges/"
        if currentDataSource == .Local {
            requestURL = "/challenges/local/new/"
        } else if currentDataSource == .Popular {
            requestURL = "/challenges/local/popular/"
        } else if currentDataSource == .Global {
            requestURL = "/challenges/"
        }
        ApiClient.getChallenges(requestURL,params: nil) { (challenges, error) -> () in
            if error == nil { // success
                self.challenges = challenges!
                self.tableView.reloadData()
                
                // REMOVE AFTER PAGING IMPLEMENTED
                if self.originalChallenges.isEmpty == true {
                    self.originalChallenges.appendContentsOf(self.challenges)
                }
            }
        }
    }
    
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162 // "average" cell height
        
        // add custom cell
        let cellNib = UINib(nibName: "FeedTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChallengesViewController.refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadTableAndData()
        refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destinationViewController = segue.destinationViewController
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        if segue.identifier == "SaveFilter" { // Returning to Home from Filter
            let filterController = segue.sourceViewController as! FilterViewController
            ChallengesViewController.filterItems = filterController.filterItems!
            loadTableAndData(); // Reload Table
        }
    }
}


extension ChallengesViewController: UITableViewDataSource {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Challenge", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Challenge") as! ChallengeDetailViewController
        ChallengeDetailViewController.challenge = challenges[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ChallengesViewController: UIScrollViewDelegate, UITableViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // when the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // TODO: REMOVE AND IMPLEMENT PAGING WHEN BACKEND READY
                challenges.appendContentsOf(originalChallenges)
                
                tableView.reloadData()
                isMoreDataLoading = false
            }
        }
    }
}