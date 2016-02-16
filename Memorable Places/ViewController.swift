//
//  ViewController.swift
//  Memorable Places
//
//  Created by León Felipe Guevara Chávez on 2016-02-16.
//  Copyright © 2016 León Felipe Guevara Chávez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager : CLLocationManager!

    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2.0
        
        myMap.addGestureRecognizer(uilpgr)
    }
    
    func action(gestureReconizer: UIGestureRecognizer) {
        if gestureReconizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureReconizer.locationInView(self.myMap)
            let newCoordinate = self.myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var title = ""
                if error == nil {
                    if let p = placemarks?[0] {
                        var subThoroughfare : String = ""
                        var thoroughfare : String = ""
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare!
                        }
                        title = "\(subThoroughfare) \(thoroughfare)"
                    }
                }
                
                if title == "" {
                    title = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.myMap.addAnnotation(annotation)
            })
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let latDelta : CLLocationDegrees = 0.01
        let lonDelta : CLLocationDegrees = 0.01
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.myMap.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

