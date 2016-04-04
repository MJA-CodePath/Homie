//
//  ProfileViewController.swift
//  Homie
//
//  Created by Justin Hill on 3/23/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
//Added this line on April 3, 2016
    let currentUser: NSString = DataService.dataService.CURRENT_USER_ID

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Added these lines on April 3, 2016
        let currentUserRef = Firebase(url: "https://mjahomie.firebaseio.com/users/\(currentUser)/username")
        currentUserRef.observeEventType(.Value, withBlock: { snapshot in
            let abc = snapshot.value as? String
            //Next line will set username label = to current user's username. 
            //Storyboard links will be made in milestone 3
            //self.username.text = abc
            print("\(snapshot.key) -> \(snapshot.value)")
        })
        


        // Do any additional setup after loading the view.
    }
    
    
    func logout() {
        
        DataService.dataService.CURRENT_USER_REF.unauth()
        //unauth is what firebase uses to logout user
        
        // Remove the user's uid from storage.
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        // Head back to Login!
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
