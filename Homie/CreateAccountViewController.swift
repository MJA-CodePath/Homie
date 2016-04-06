//
//  CreateAccountViewController.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func createAccount(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        if username != "" && email != "" && password != "" {
            DataService.sharedInstance.createNewAccount(email!, password: password!, username: username!, completion: { (user, error) in
                if error != nil {
                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                    print(error)
                } else if let loggedInUser = user {
                    User.currentUser = loggedInUser
                    NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName(userWasCreatedNotification, object: nil)
                } else {
                    self.signupErrorAlert("Oops!", message: "Something went wrong.")
                }
            })
        } else {
            signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
    }
    
    
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    func signupErrorAlert(title: String, message: String) {
        // Called upon signup error to let the user know signup didn't work.
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
