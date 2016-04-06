//
//  ActivityCell.swift
//  Homie
//
//  Created by Justin Hill on 4/5/16.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var detailsView: Bool?
    
    
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
            nameLabel.text = post.eventName
            postTextLabel.text = post.text
            /*if post.user?.profileImage != nil {
             userAvi.setImageWithURL(NSURL(string: (tweet.user?.profileImageURL)!)!)
             }*/
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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



/* original extension NSDate code retrieved from: http://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
 By: Leo Dabus*/
extension NSDate {
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if weeksFrom(date)   > 0 {
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            return formatter.stringFromDate(date)   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
