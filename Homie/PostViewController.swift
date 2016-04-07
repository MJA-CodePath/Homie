//
//  PostViewController.swift
//
//  Created by Justin Hill on 2/26/16.
//

import UIKit

class PostViewController: UIViewController {

    
    @IBOutlet weak var postField: UITextView!
    var event: PinEvent?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postField.text = ""
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
    
    
    @IBAction func onPost(sender: AnyObject) {
        let status = postField.text
        print("POST: \(status!)")
        if (status?.characters.count <= 140) {
            postField.resignFirstResponder()
            let newPost = Post(eventid: event!.id!, eventname: event!.name, posttext: status)
            newPost.sendPost()
        }
        self.dismissViewControllerAnimated(true) {
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
