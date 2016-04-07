//
//  ProfileViewController.swift
//  Homie
//
//  Created by Justin Hill on 3/23/16.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var activityTable: UITableView!
    var editable: Bool?
    var user: User?
    var userID: String?
    var userDict: NSMutableDictionary?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.*/
        if editable == true {
            nameView.text = ""
            nameView.layer.borderWidth = 0.75
            nameView.userInteractionEnabled = true
            nameView.becomeFirstResponder()
            bioView.text = "Add bio..."
            bioView.layer.borderWidth = 0.75
            bioView.userInteractionEnabled = true
        } else {
            endEventEditing()
            nameView.text = user?.name
            bioView.text = user?.biography
        }
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.logout()
    }
    
    
    @IBAction func onSaveButton(sender: AnyObject) {
        if nameView.text != "" && bioView.text != "" && bioView.text != "Add bio..." {
            userDict?.setObject(nameView.text, forKey: "name")
            userDict?.setObject(bioView.text, forKey: "bio")
            user = DataService.sharedInstance.sendUser(userDict!)
            createdUser = false
            endEventEditing()
        }
        
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true) { 
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user?.posts != nil {
            return user!.posts!.count
        } else {
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! ActivityCell
        cell.post = user?.posts?[indexPath.row]
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("pToEventSegue", sender: cell)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if user?.photos != nil {
            return user!.photos!.count
        } else {
            return 0
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        cell.imageView.image = user?.photos?[indexPath.row]
        return cell
    }
    
    
    func endEventEditing() {
        editable = false
        nameView.layer.borderWidth = 0.0
        nameView.userInteractionEnabled = false
        bioView.layer.borderWidth = 0.0
        bioView.userInteractionEnabled = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        let vc = segue.destinationViewController as! EventViewController
        vc.editable = false
        let postCell = sender as! PostCell
        vc.pinEventID = postCell.post.eventID
        
    }
    

}
