//
//  VCMapView.swift
//  OneUp-iOS
//
//  Created by Harris Christiansen on 3/3/16.
//  Copyright © 2016 Kiwi. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ChallengePin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                
//                let btnImage = UIImage(named: "arrow.png")
//                let btn = UIButton(type: .Custom)
//                btn.setImage(btnImage, forState: .Normal)
//                view.rightCalloutAccessoryView = btn
            }
            
            // Set Pin Color
            switch annotation.discipline {
                case "Timed":
                    view.pinTintColor = UIColor.redColor()
                default:
                    view.pinTintColor = UIColor.blueColor()
            }
            
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let storyboard = UIStoryboard(name: "Challenge", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("Challenge") as UIViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}