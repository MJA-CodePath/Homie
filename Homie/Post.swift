//
//  Post.swift
//  Homie
//
//  Created by Justin Hill on 4/5/16.
//

import UIKit

class Post: NSObject {
    var user: User?
    var event: PinEvent?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var ID: Int?
    
    init(dictionary: NSDictionary){
        user = User.createUser(dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        ID = dictionary["id"] as? Int
        event = dictionary["event"] as? PinEvent
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
