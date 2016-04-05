//
//  EventViewController.swift
//  Homie
//
//  Created by Justin Hill on 3/23/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    
    var coordinate: CLLocationCoordinate2D?
    var editable: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        
        let enclosure: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate!, enclosure, enclosure)
        map.setRegion(coordinateRegion,animated: true)
        map.setCenterCoordinate(coordinate!, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        map.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onSaveEvent() {
        
        //save to firebase firebase
        
        dismissViewControllerAnimated(true, completion: nil)
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
