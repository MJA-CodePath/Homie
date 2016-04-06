//
//  PostCell.swift
//  Homie
//
//  Created by Justin Hill on 4/5/16.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var userAvi: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var detailsView: Bool?
    @IBOutlet weak var aviButton: UIButton!
    
    
    var post: Post! {
        didSet {
            if detailsView == true {
                let dateFormatter = NSDateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate("MMM/d/y HH:mm")
                let date = dateFormatter.stringFromDate(post.createdAt!)
                timeLabel.text = date
            } else {
                let timeElapsed = NSDate().offsetFrom(post.createdAt!)
                timeLabel.text = timeElapsed
            }
            nameLabel.text = post.userName
            usernameLabel.text = "@\(post.userUsername)"
            postTextLabel.text = post.text
            userAvi.image = nil
            /*if post.user?.profileImage != nil {
                userAvi.setImageWithURL(NSURL(string: (tweet.user?.profileImageURL)!)!)
            }*/
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userAvi.layer.cornerRadius = 5
        userAvi.clipsToBounds = true
        postTextLabel.preferredMaxLayoutWidth = postTextLabel.frame.size.width
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postTextLabel.preferredMaxLayoutWidth = postTextLabel.frame.size.width
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

