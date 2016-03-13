//
//  ViewController.swift
//  Homie
//
//  Created by Alishah on 3/12/16.
//  Copyright © 2016 Alishah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func logout(sender: AnyObject) {
        
        DataService.dataService.CURRENT_USER_REF.unauth()
        //unauth is what firebase uses to logout user
        
        // Remove the user's uid from storage.
        
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        
        // Head back to Login!
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

