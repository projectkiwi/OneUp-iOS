//
//  ChallengesViewController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 2/25/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var challenges = [Challenge]()
    var filterItems = [String: Bool]()
    var originalChallenges = [Challenge]() // REMOVE AFTER PAGING IMPLEMENTED: dummy data till backend develops paging
    var isMoreDataLoading = false // used for infinate scroll

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
                
                // REMOVE AFTER PAGING IMPLEMENTED
                if self.originalChallenges.isEmpty == true {
                    self.originalChallenges.appendContentsOf(self.challenges)
                }
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
        
        // add custom cell
        let cellNib = UINib(nibName: "FeedTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: FeedTableViewCell.cellIdentifier)
        
        // pull down to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getData()
        refreshControl.endRefreshing()
    }

    
    @IBAction func onFilterPress(sender: AnyObject) {
//        let filterController = FilterViewController()
//        presentViewController(filterController, animated: true) { () -> Void in
//            print("presented filtered view controller")
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if let destinationViewController = destinationViewController as? FilterViewController {
            destinationViewController.delegate = self
            
            if filterItems.count > 0 {
                print("replacing items")
                destinationViewController.filterItems = self.filterItems
            }
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
        let controller = storyboard.instantiateViewControllerWithIdentifier("Challenge") as UIViewController
        
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

extension ChallengesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FilterViewController, didUpdateFilters filters: [String: Bool]) {
        // implement catergory filtering with backend here... //
        
        filterItems = filters
        tableView.reloadData()
        
        // only grab filter params that were selected
        let filtered = filters.filter { (s: String, filterBool: Bool) -> Bool in
            if filterBool == true {
                return true
            }
            return false
        }
        
        for filteredItem in filtered {
            print(filteredItem)
        }
        
        // TODO: Once backend filtering is complete add ApiClient filter functionality
    }
}