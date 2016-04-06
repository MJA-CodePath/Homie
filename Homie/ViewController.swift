//
//  ViewController.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var displayControl: UISegmentedControl!
    var toAddCoor: CLLocationCoordinate2D?
    var added = false
    var eventPins: [PinEvent] = []
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            if let location = locationManager.location {
                centerMapOnLocation(location)
            }
        }
        DataService.sharedInstance.retrievePins { (PinEvents, error) in
            if error == nil {
                self.eventPins = PinEvents
                for events in self.eventPins {
                    self.placePin(events.coordinate!, pinEvent: events)
                }
            } else {
                print("FFFF")
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.profileSegue), name: userWasCreatedNotification, object: nil)
    }
    
    
    @IBAction func onMenuButton(sender: AnyObject) {
        
    }
    
    
    func profileSegue() {
        performSegueWithIdentifier("profileSegue", sender: true)
    }

    
    @IBAction func onProfileButton(sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: false)
    }
    

    @IBAction func onMapLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            print("Long pressed.")
            let touchPoint = sender.locationInView(map)
            toAddCoor = map.convertPoint(touchPoint, toCoordinateFromView: map)
            placePin(toAddCoor!, pinEvent: nil)
            performSegueWithIdentifier("addPinSegue", sender: true)
        }
    }
    
    
    func placePin(coor: CLLocationCoordinate2D, pinEvent: PinEvent?) {
        print("lat: \(coor.latitude.description), lon: \(coor.longitude.description)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor
        if pinEvent != nil {
            annotation.title = pinEvent!.name
            annotation.subtitle = pinEvent!.description
        }
        map.addAnnotation(annotation)
    }
    
    
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("pin tapped, view pin")
        performSegueWithIdentifier("addPinSegue", sender: false)
        map.deselectAnnotation(view.annotation, animated: false)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addPinSegue" {
            let vc = segue.destinationViewController as! EventViewController
            vc.coordinate = toAddCoor
            if sender == nil {
                
            } else if sender as! Bool == true {
                vc.editable = true
            } else if sender as! Bool == false {
                vc.editable = false
            }
        } else if segue.identifier == "profileSegue" {
            let vc = segue.destinationViewController as! ProfileViewController
            vc.user = User.currentUser
            if sender == nil {
                
            } else if sender as! Bool == true {
                vc.editable = true
            } else if sender as! Bool == false {
                vc.editable = false
            }
        }
     }

}

