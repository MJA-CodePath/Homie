//
//  ViewController.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var toAddCoor: CLLocationCoordinate2D?
    
    var added = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.profileSegue), name: userWasCreatedNotification, object: nil)
    }
    
    func profileSegue() {
        performSegueWithIdentifier("profileSegue", sender: true)
    }

    
    @IBAction func onProfileButton(sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onMapLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            print("Long pressed.")
            let touchPoint = sender.locationInView(map)
            toAddCoor = map.convertPoint(touchPoint, toCoordinateFromView: map)
            placePin(toAddCoor!)
            performSegueWithIdentifier("addPinSegue", sender: true)
        }
    }
    
    func placePin(coor: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coor
        //annotation.title = "(\(annotation.coordinate.latitude),\(annotation.coordinate.longitude))"
        map.addAnnotation(annotation)
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("pin tapped, view pin")
        performSegueWithIdentifier("showPinSegue", sender: false)
        map.deselectAnnotation(view.annotation, animated: false)
    }
    
    
    

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

