//
//  MapViewController.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var challenges = [Challenge]()
    var challengePins = [ChallengePin]()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self // VCMapView MapViewController Extension
        
        loadData()
        
        // Zoom Map To US
        let initialLocation = CLLocation(latitude: 43, longitude: -96)
        centerMapOnLocation(initialLocation,regionRadius: 2400000)
    }
    @IBAction func listButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            print("dismissing back to list")
        }
    }
    
    func loadData() {
        ApiClient.getChallenges(nil) { (challenges, error) -> () in
            if error == nil { // success
                self.challenges = challenges!
            }
            self.challengePins = ChallengePin.pinsFromChallenges(challenges!)
            
            self.showPins()
        }
    }
    
    func showPins() {
        self.mapView.removeAnnotations(self.mapView.annotations) // Clear Old Pins
        self.mapView.addAnnotations(self.challengePins) // Add Current Pins
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}