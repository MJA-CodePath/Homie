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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.*/
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (editable == true) {
            nameView.userInteractionEnabled = true
            bioView.userInteractionEnabled = true
        } else {
            endEventEditing()
        }
    }
    
    @IBAction func onSaveButton(sender: AnyObject) {
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user?.activity != nil {
            return user!.activity!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! ActivityCell
        cell.post = user?.activity![indexPath.row]
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
        cell.imageView.image = user?.photos![indexPath.row]
        return cell
    }
    
    
    
    
    
    
    func endEventEditing() {
        editable = false
        nameView.userInteractionEnabled = false
        bioView.userInteractionEnabled = false
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
