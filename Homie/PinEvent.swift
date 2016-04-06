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
    
    
    init(lon: Double, lat: Double, na: String, de: String) {
        longitude = lon
        latitude = lat
        coordinate = CLLocationCoordinate2D(latitude: lon, longitude: lat)
        name = na
        eventDescription = de
    }

    
    init(dictionary: NSDictionary){
        id = dictionary["id"] as? String
        let longit = dictionary["longitude"] as? NSString
        let latit = dictionary["latitude"] as? NSString
        longitude = (longit?.doubleValue)!
        latitude = (latit?.doubleValue)!
        coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        name = dictionary["name"] as! String
        eventDescription = dictionary["description"] as? String
        if let postData = dictionary["posts"] as? NSDictionary {
            posts = Post.postsWithArray(postData)
        }
        if let imageData = dictionary["images"] as? [NSString] {
            eventImages = DataService.getImagesFromString(imageData)
        }
    }
    
    
    class func pinsArray(dictionary: NSDictionary) -> [PinEvent] {
        var pinEvents = [PinEvent]()
        if let allKeys = dictionary.allKeys as? [String] {
            for key in allKeys {
                let objects = dictionary[key] as! NSDictionary
                pinEvents.append(PinEvent(dictionary: objects))
            }
        }
        return pinEvents
    }

}
