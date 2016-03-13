//
//  DataService.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit
import Firebase

let BASE_URL = "https://mja.firebaseio.com/"

class DataService {
    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    //private var _MAP_REF = Firebase(url: "\(BASE_URL)/map")
    //not sure how map works but there will be a specific data set for maps under user
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    /*var MAP_REF: Firebase {
        return _JOKE_REF
    }*/
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        
        // A User is created.
        
        USER_REF.childByAppendingPath(uid).setValue(user)
        //set value is what sends data to firebase, in this case it sent data of a created user to firebase
    }
}
