//
//  DataService.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//

import UIKit
import Firebase

let BASE_URL = "https://mjahomie.firebaseio.com/" as String

class DataService {
    private var baseURL: String
    private var _base_ref: Firebase
    private var _user_ref: Firebase
    private var _event_ref: Firebase
    private var _post_ref: Firebase
    
    init(bURL: String) {
        baseURL = bURL
        _base_ref = Firebase(url: baseURL)
        _user_ref = _base_ref.childByAppendingPath("user/")
        _event_ref = _base_ref.childByAppendingPath("pinEvents/")
        _post_ref = _base_ref.childByAppendingPath("posts/")
    }
    
    class var sharedInstance: DataService {
        struct Static {
            static let dataService = DataService(bURL: BASE_URL)
        }
        return Static.dataService
    }
    
    
    
    /*USER RELATED FUNCTIONS*/
    func login(email: String, password: String, completion: (user: User?, error: NSError?) -> ()) {
        _base_ref.authUser(email, password: password) { (err: NSError!, data: FAuthData!) in
            if err != nil {
                print(err)
                completion(user: nil, error: err)
            } else {
                let loggedInUser = self._user_ref.childByAppendingPath(data.uid)
                loggedInUser.observeEventType(.Value, withBlock: {
                    snapshot in
                    print("\(snapshot.key) -> \(snapshot.value)")
                    if let _ = snapshot {
                        if let data = snapshot.value as? NSDictionary {
                            let newUser = User(dictionary: data)
                            completion(user: newUser, error: nil)
                        }
                    }
                })
            }
        }
    }
    

    func createNewAccount(email: String, password: String, username: String, completion: (userDict: NSMutableDictionary?, error: NSError?) -> ()) {
        _base_ref.createUser(email, password: password) { (err: NSError!) in
            if err != nil {
                completion(userDict: nil, error: err)
            } else {
                self._base_ref.authUser(email, password: password, withCompletionBlock: { (erro: NSError!, data: FAuthData!) in
                    if erro != nil {
                        print(erro)
                        completion(userDict: nil, error: erro)
                    } else {
                        let passUser = ["uid" : data.uid,
                                        "email" : email,
                                        "username" : username] as NSMutableDictionary
                        completion(userDict: passUser, error: nil)
                    }
                })
            }
        }
    }
    
    
    func sendUser(dictionary: NSDictionary) -> User {
        let newUserPath = _user_ref.childByAppendingPath(dictionary["uid"] as! String)
        newUserPath.setValue(dictionary)
        _currentUser = User(dictionary: dictionary)
        return _currentUser!
    }
    
    
    func getUser(uid: String, completion: (user: User, error: NSError?) -> ()) {
        let userPath = _user_ref.childByAppendingPath(uid)
        userPath.observeEventType(.Value, withBlock: {
            snapshot in
            if let _ = snapshot {
                if let data = snapshot.value as? NSDictionary {
                    completion(user: User(dictionary: data), error: nil)
                }
            }
        })
    }
    
    
    
    /*PIN EVENT RELATED FUNCTIONS*/
    func retrievePin(pid: String, completion: (pinEvent: PinEvent, error: NSError?) -> ()) {
        let ref = _event_ref.childByAppendingPath(pid)
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
            if let data = snapshot.value as? NSDictionary {
                completion(pinEvent: PinEvent(dictionary: data) , error: nil)
            }
        })
    }
    
    
    func retrievePins(completion: (PinEvents: [PinEvent], error: NSError?) -> ()) {
        _event_ref.observeEventType(.Value, withBlock: {
            snapshot in
            print("\(snapshot.key) -> \(snapshot.value)")
            if let data = snapshot.value as? NSDictionary {
                completion(PinEvents: PinEvent.pinsArray(data), error: nil)
            }
        })
    }
    
    
    func newPin(pin: PinEvent) -> PinEvent {
        let newPinRef = _event_ref.childByAutoId()
        pin.id = newPinRef.key
        let passPin = ["id" : pin.id!,
                       "name" : pin.name,
                       "description" : pin.eventDescription!,
                       "longitude" : pin.longitude.description,
                       "latitude" : pin.latitude.description] as NSDictionary
        newPinRef.setValue(passPin)
        return pin
    }
    
    /*
    func updatePin(pinEvent: PinEvent, na: String?, ed: String?, ei: UIImage?, it: [Post]?) {
        let eventRef = _event_ref.childByAppendingPath(pinEvent.id!)
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
            if let imageString = DataService.getStringFromImage(ei) {
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
     */
    
    
    

    /*POST RELATED FUNCTIONS*/
    func newImage(image: UIImage) {
        
    }
    
    
    func newPost(post: Post) -> Post {
        let postPath = _post_ref.childByAutoId()
        post.ID = postPath.key
        let userPostPath = _user_ref.childByAppendingPath(post.userID).childByAppendingPath("posts").childByAppendingPath(postPath.key)
        let eventPostPath = _event_ref.childByAppendingPath(post.eventID).childByAppendingPath("posts").childByAppendingPath(postPath.key)
        let pass = ["userID" : post.userID!,
                    "userUsername" : post.userUsername!,
                    "userName" : post.userName!,
                    "text" : post.text!,
                    "created_at" : post.createdAtString!,
                    "ID" : post.ID!,
                    "eventID" : post.eventID!,
                    "eventName" : post.eventName!] as NSDictionary
        postPath.setValue(pass)
        userPostPath.setValue(pass)
        eventPostPath.setValue(pass)
        return post
    }
    
    
    
    /*DATA RELATED FUNCTIONS*/
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
    

}
