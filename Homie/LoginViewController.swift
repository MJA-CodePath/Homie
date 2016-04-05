//
//  LoginViewController.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func tryLogin(sender: AnyObject) {
        
        let email = emailField.text
        let password = passwordField.text
        
        if (email != nil && password != nil) {
            DataService.sharedInstance.login(email!, password: password!, completion: { (user, error) in
                if error != nil {
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                } else if let loggedInUser = user {
                    User.currentUser = loggedInUser
                    NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
                } else {
                    self.loginErrorAlert("Oops!", message: "Something went wrong")
                }
            })
        } else {
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
        }
        
    }
    
    
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
