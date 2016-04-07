//
//  User.swift
//  Homie
//
//  Created by Justin Hill on 3/28/16.
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
    var posts: [Post]?
    var dictionary: NSDictionary?
    
    
    init(na: String?, un: String, bio: String?) {
        name = na
        username = un
        biography = bio
    }
    
    
    init(dictionary: NSDictionary) {
        uid = dictionary["uid"] as? String
        name = dictionary["name"] as? String
        username = dictionary["username"] as? String
        biography = dictionary["bio"] as? String
        if let imageArray = dictionary["photos"] as? [NSString] {
            photos = DataService.getImagesFromString(imageArray)
        }
        if let postArray = dictionary["posts"] as? NSDictionary {
            posts = Post.postsWithArray(postArray)
        }
        self.dictionary = dictionary
    }
    
    
    class func logout() {
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
                        _currentUser = User(dictionary: dictionary!)
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
