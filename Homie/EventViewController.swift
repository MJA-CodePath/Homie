//
//  EventViewController.swift
//  Homie
//
//  Created by Justin Hill on 3/23/16.
//

import UIKit
import MapKit

class EventViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var nameview: UITextView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var activityTable: UITableView!
    
    var coordinate: CLLocationCoordinate2D?
    var editable: Bool?
    var pinEvent: PinEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        let enclosure: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate!, enclosure, enclosure)
        map.setRegion(coordinateRegion,animated: true)
        map.setCenterCoordinate(coordinate!, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        map.addAnnotation(annotation)
        map.userInteractionEnabled = false
     
        nameview.layer.borderColor = UIColor.blackColor().CGColor
        descriptionView.layer.borderColor = UIColor.blackColor().CGColor
        if editable == true {
            nameview.text = "Name"
            nameview.layer.borderWidth = 0.75
            descriptionView.text = "Add description..."
            descriptionView.layer.borderWidth = 0.75
        } else {
            endEventEditing()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (editable == true) {
            nameview.userInteractionEnabled = true
            descriptionView.userInteractionEnabled = true
        } else {
            endEventEditing()
        }
    }


    @IBAction func onPost(sender: AnyObject) {
        performSegueWithIdentifier("postSegue", sender: nil)
    }
    
    
    @IBAction func onSaveEvent() {
        if title != "" && description != "" {
            let title = nameview.text
            let description = descriptionView.text
            let newPin = PinEvent.saveNewPin(title!, lon: coordinate!.longitude, lat: coordinate!.latitude)
            PinEvent.updatePin(newPin, na: nil, ed: description, ei: nil, it: nil)
            endEventEditing()
        } else {
            saveEventAlert("Oops!", message: "Don't forget to enter a name and a description.")
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pinEvent?.posts != nil {
            return pinEvent!.posts!.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        cell.post = pinEvent?.posts![indexPath.row]
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.aviButton.tag = indexPath.row
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pinEvent?.eventImages != nil {
            return pinEvent!.eventImages!.count
        } else {
            return 0
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        cell.imageView.image = pinEvent?.eventImages![indexPath.row]
        return cell
    }
    
    
    
    
    
    func endEventEditing() {
        editable = false
        nameview.userInteractionEnabled = false
        nameview.layer.borderWidth = 0.0
        descriptionView.userInteractionEnabled = false
        descriptionView.layer.borderWidth = 0.0
    }
    
    
    func saveEventAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
