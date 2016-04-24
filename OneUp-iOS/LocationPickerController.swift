//
//  LocationPickerController.swift
//  OneUp-iOS
//
//  Created by Martynas Kausas on 4/24/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit

@objc protocol LocationPickerControllerDelegate {
    optional func locationPickerController(locationPickerController: LocationPickerController, didSelectLocation location: String)
}

class LocationPickerController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var locationItems: [String]? = ["One", "Two", "Three"]
    var delegate: LocationPickerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LocationPickerController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationItems!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath)
        cell.textLabel?.text = locationItems![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.delegate?.locationPickerController!(self, didSelectLocation: self.locationItems![indexPath.row])
        }
    }
}

extension LocationPickerController: UITableViewDelegate {
    
}