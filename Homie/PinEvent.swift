//
//  PinEvent.swift
//  Homie
//
//  Created by Justin Hill on 3/28/16.
//

import UIKit
import Firebase
import MapKit

class PinEvent: NSObject {

    var id: String?
    var coordinate: CLLocationCoordinate2D?
    var longitude: Double
    var latitude: Double
    var name: String
    var eventDescription: String?
    var eventImages: [UIImage]?
    var posts: [Post]?
    
    init(lon: Double, lat: Double, na: String, pid: String?) {
        //Initialize class vars
        longitude = lon
        latitude = lat
        coordinate = CLLocationCoordinate2D(latitude: lon, longitude: lat)
        name = na
        id = pid
        eventImages = [UIImage]()
        posts = [Post]()
    }

    
    class func saveNewPin(na: String, lon: Double, lat: Double) -> PinEvent {
        let eventsRef = Firebase(url:"https://mjahomie.firebaseio.com/pinEvents/")
        let newPinRef = eventsRef.childByAutoId()
        let id = newPinRef.key
        let passPin = ["id" : id,
                       "name" : na,
                       "longitude" : lon.description,
                       "latitude" : lat.description,
                       "posts" : [Post](),
                       "images" : [String]()] as NSDictionary
        newPinRef.setValue(passPin)
        return PinEvent(lon: lon, lat: lat, na: na, pid: id)
    }
    
    
    class func updatePin(pinEvent: PinEvent, na: String?, ed: String?, ei: UIImage?, it: [Post]?) {
        let eventRef = Firebase(url:"https://mjahomie.firebaseio.com/pinEvents/\(pinEvent.id!)")
        if na != nil {
            pinEvent.name = na!
            eventRef.childByAppendingPath("name")
        }
        if ed != nil {
            pinEvent.eventDescription = ed
            eventRef.childByAppendingPath("description").setValue(ed)
        }
        if ei != nil {
            if pinEvent.eventImages == nil {
                pinEvent.eventImages = [UIImage]()
            }
            let index = pinEvent.eventImages!.count + 1
            pinEvent.eventImages!.append(ei!)
            if let imageString = getStringFromImage(ei) {
                eventRef.childByAppendingPath("images").updateChildValues([index : imageString])
            }
        }
        if it != nil {
            if pinEvent.posts == nil {
                pinEvent.posts = [Post]()
            }
            var index = pinEvent.posts!.count + 1
            pinEvent.posts!.appendContentsOf(it!)
            let passItems = NSDictionary()
            for thing in it! {
                passItems.setValue(thing, forKey: index.description)
                index += 1;
            }
            eventRef.childByAppendingPath("items").updateChildValues(passItems as [NSObject : AnyObject])
        }
    }
    
    
    class func retrievePins(completion: (PinEvents: [PinEvent], error: NSError?) -> ()) {
        let myRootRef = Firebase(url:"https://mjahomie.firebaseio.com/pinEvents")
        myRootRef.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
            completion(PinEvents: pinsArray(snapshot.value as! NSDictionary), error: nil)
        })
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
    
    
    class func pinsArray(dictionary: NSDictionary) -> [PinEvent] {
        var pinEvents = [PinEvent]()
        if let allKeys = dictionary.allKeys as? [String] {
            for key in allKeys {
                let objects = dictionary[key] as! NSDictionary
                let longit = objects["longitude"] as? NSString
                let latit = objects["latitude"] as? NSString
                let newEvent = PinEvent(lon: (longit?.doubleValue)!, lat: (latit?.doubleValue)!, na: objects["name"] as! String, pid: objects["id"] as? String)
                newEvent.eventDescription = objects["description"] as? String
                newEvent.posts = objects["posts"] as? [Post]
                if let imageData = objects["images"] as? [NSString] {
                    newEvent.eventImages = getImagesFromString(imageData)
                }
                pinEvents.append(newEvent)
            }
        }
        return pinEvents
    }

    
}
