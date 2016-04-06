//
//  Post.swift
//  Homie
//
//  Created by Justin Hill on 4/5/16.
//

import UIKit

class Post: NSObject {
    
    var userID: String?
    var userUsername: String?
    var userName: String?
    var eventID: String?
    var eventName: String?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var ID: String?
    
    
    init(eventid: String, eventname: String, posttext: String) {
        userID = _currentUser?.uid
        userUsername = _currentUser?.username
        userName = _currentUser?.name
        eventID = eventid
        eventName = eventname
        text = posttext
    }
    
    
    init(dictionary: NSDictionary){
        userID = dictionary["userID"] as? String
        userUsername = dictionary["userUsername"] as? String
        userName = dictionary["userName"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        ID = dictionary["ID"] as? String
        eventID = dictionary["eventID"] as? String
        eventName = dictionary["eventName"] as? String
    }
    
    
    func sendPost() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = NSDate()
        createdAtString = formatter.stringFromDate(NSDate())
        DataService.sharedInstance.newPost(self)
    }
    
    
    class func postsWithArray(dictionary: NSDictionary) -> [Post] {
        var posts = [Post]()
        if let allKeys = dictionary.allKeys as? [String] {
            for key in allKeys {
                let objects = dictionary[key] as! NSDictionary
                posts.append(Post(dictionary: objects))
            }
        }
        return posts
    }
    
}
