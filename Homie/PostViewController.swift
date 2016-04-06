//
//  PostViewController.swift
//
//  Created by Justin Hill on 2/26/16.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var postField: UITextField!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        postField.becomeFirstResponder()
    }

    @IBAction func onCancel(sender: AnyObject) {
        postField.resignFirstResponder()
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        let status = postField.text?.stringByAddingPercentEncodingWithAllowedCharacters(.alphanumericCharacterSet())
        print("POST: \(status!)")
        if (status?.characters.count <= 140) {
            postField.resignFirstResponder()
            var pass: [String : AnyObject!]
            pass = ["status" : status]
            //DataService.sharedInstance.post()
        }
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
