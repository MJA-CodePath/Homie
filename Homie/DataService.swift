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
    
    init(bURL: String) {
        baseURL = bURL
        _base_ref = Firebase(url: baseURL)
        _user_ref = _base_ref.childByAppendingPath("user/")
        _event_ref = _base_ref.childByAppendingPath("pinEvents/")
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
                            let newUser = User.createUser(data)
                            completion(user: newUser, error: nil)
                        }
                    }
                })
            }
        }
    }
    

    func createNewAccount(email: String, password: String, username: String, completion: (user: User?, error: NSError?) -> ()) {
        _base_ref.createUser(email, password: password) { (err: NSError!) in
            if err != nil {
                completion(user: nil, error: err)
            } else {
                self._base_ref.authUser(email, password: password, withCompletionBlock: { (erro: NSError!, data: FAuthData!) in
                    if erro != nil {
                        print(erro)
                        completion(user: nil, error: erro)
                    } else {
                        let passUser = ["uid" : data.uid,
                                        "email" : email,
                                        "username" : username] as NSDictionary
                        self._user_ref.childByAppendingPath(data.uid).setValue(passUser)
                        let newUser = User.createUser(passUser)
                        completion(user: newUser, error: nil)
                    }
                })
            }
        }
    }
    
    
    func getUser(uid: String) -> User? {
        var gotUser: User?
        let userPath = _user_ref.childByAppendingPath(uid)
        userPath.observeEventType(.Value, withBlock: {
            snapshot in
            if let _ = snapshot {
                if let data = snapshot.value as? NSDictionary {
                    gotUser = User.createUser(data)
                }
            }
        })
        return gotUser
    }
    
    
    /*POST RELATED FUNCTIONS*/
    
    
    func retreivePosts() {
        
    }
    
    
    func newPost(post: Post) {
        let pass = ["userID" : (post.user?.uid)!,
                    "text" : post.text!,
                    "created_at" : post.createdAtString!,
                    "id" : post.ID!,
                    "eventID" : (post.event?.id)!] as NSDictionary
        let postPath = _user_ref.childByAppendingPath(post.user!.uid).childByAutoId()
        postPath.setValue(pass)
    }
    
    
    
    
    
    
    
    
    
    
}
