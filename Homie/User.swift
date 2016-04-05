//
//  User.swift
//  Homie
//
//  Created by Justin Hill on 3/28/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUser" as String
let userWasCreatedNotification = "userWasCreatedNotification"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {

    var uid: String?
    var name: String?
    var username: String?
    var biography: String?
    var photos: [UIImage]?
    var activity: [PinEvent]?
    var dictionary: NSDictionary?
    
    init(na: String?, un: String, bio: String?) {
        //initialize user
        name = na
        username = un
        biography = bio
    }
    
    class func createUser(dictionary: NSDictionary) -> User? {
        if let newUserName = dictionary["username"] as? String {
            let newUser = User(na: dictionary["name"] as? String, un: newUserName, bio: dictionary["bio"] as? String)
            newUser.uid = dictionary["uid"] as? String
            newUser.dictionary = dictionary
            if let imageArray = dictionary["photos"] as? [NSString] {
                newUser.photos = PinEvent.getImagesFromString(imageArray)
            }
            if let pinArray = dictionary["activity"] as? [NSDictionary] {
                newUser.activity = PinEvent.pinsArray(pinArray)
            }
            return newUser
        } else {
            return nil
        }
    }
    
    
    func logout() {
        User.currentUser = nil
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                //logged out or just boot up
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary: NSDictionary?
                    do {
                        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        _currentUser = User.createUser(dictionary!)!
                    } catch {
                        print(error)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            //need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                    NSUserDefaults.standardUserDefaults().synchronize()
                } catch {
                    print(error)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    
    
    
}
