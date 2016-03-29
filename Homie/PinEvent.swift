//
//  PinEvent.swift
//  Homie
//
//  Created by Justin Hill on 3/28/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit

class PinEvent: NSObject {

    var longitude: Float?
    var latitude: Float?
    var name: String?
    var eventDescription: String?
    var eventImages: [UIImage]?
    var items: [String]?
    
    init(lon: Float, lat: Float, na: String) {
        //Initialize class vars
        longitude = lon
        latitude = lat
        name = na
    }
    
    class func pinsArray(Array: [AnyObject]) -> [PinEvent] { //change from AnyObject to Firebase Object
        var pins = [PinEvent]()
        for AnyObject in Array {
            pins.append(PinEvent(lon: 1.0, lat: 1.0, na: "Name")) //placeholder values
        }
        return pins
    }
    
    
    
}
