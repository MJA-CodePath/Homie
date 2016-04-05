//
//  PinEvent.swift
//  Homie
//
//  Created by Justin Hill on 3/28/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit
import Firebase

class PinEvent: NSObject {

    var longitude: Float
    var latitude: Float
    var name: String
    var eventDescription: String?
    var eventImages: [UIImage]
    var items: [String]
    
    init(lon: Float, lat: Float, na: String) {
        //Initialize class vars
        longitude = lon
        latitude = lat
        name = na
        eventImages = [UIImage]()
        items = [String]()
    }

    
    class func saveNewPin(na: String, lon: Float, lat: Float) {
        let eventsRef = Firebase(url:"https://mjahomie.firebaseio.com/pinEvents/")
        let passPin = ["name" : na,
                      "longitude" : lon.description,
                      "latitude" : lat.description,
                      "items" : [String](),
                      "images" : [String]()] as NSDictionary
        eventsRef.childByAppendingPath(na).setValue(passPin)
    }
    
    
    class func updatePin(pinEvent: PinEvent, na: String, ed: String?, ei: UIImage?, it: [String]?) {
        let eventRef = Firebase(url:"https://mjahomie.firebaseio.com/pinEvents/\(na)")
        if ed != nil {
            pinEvent.eventDescription = ed
            eventRef.childByAppendingPath("description").setValue(ed)
        }
        if ei != nil {
            let index = pinEvent.eventImages.count + 1
            pinEvent.eventImages.append(ei!)
            if let imageString = getStringFromImage(ei) {
                eventRef.childByAppendingPath("images").updateChildValues([index : imageString])
            }
        }
        if it != nil {
            var index = pinEvent.items.count + 1
            pinEvent.items.appendContentsOf(it!)
            let passItems = NSDictionary()
            for thing in it! {
                passItems.setValue(thing, forKey: index.description)
                index += 1;
            }
            eventRef.childByAppendingPath("items").updateChildValues(passItems as [NSObject : AnyObject])
        }
    }
    
    
    class func retrievePins() -> [PinEvent] {
        let myRootRef = Firebase(url:"https://mjahomie.firebaseio.com/pinEvents")
        var pinEvents = [PinEvent]()
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            pinEvents =  pinsArray(snapshot.value as! [NSDictionary])
        })
        return pinEvents
    }
    
    
    class func getStringFromImage(image: UIImage?) -> String? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image) {
                return imageData.base64EncodedStringWithOptions([])
            }
        }
        return nil
    }
    
    
    class func getImagesFromString(imageArray: [NSString]) -> [UIImage] {
        var images = [UIImage]()
        for imageString in imageArray {
            let imageData = imageString.dataUsingEncoding(NSUTF8StringEncoding)
            if let image = UIImage(data: imageData!) {
                images.append(image)
            }
        }
        return images
    }
    
    
    class func pinsArray(dictionary: [NSDictionary]) -> [PinEvent] {
        var pinEvents = [PinEvent]()
        for objects in dictionary {
            let newEvent = PinEvent(lon: objects["longitude"] as! Float, lat: objects["latitude"] as! Float, na: objects["name"] as! String)
            newEvent.eventDescription = objects["description"] as? String
            newEvent.items = (objects["items"] as? [String])!
            if let imageData = objects["images"] as? [NSString] {
                newEvent.eventImages = getImagesFromString(imageData)
            }
            pinEvents.append(newEvent)
        }
        return pinEvents
    }

    
}
