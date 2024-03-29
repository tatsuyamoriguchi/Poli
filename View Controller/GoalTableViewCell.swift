//
//  GoalTableViewCell.swift
//  Poli
//
//  Created by Tatsuya Moriguchi on 7/21/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var goalDescriptionTextView: UITextView!
    @IBOutlet weak var goalDueDateLabel: UILabel!
    @IBOutlet weak var goalProgressView: UIProgressView!
    @IBOutlet weak var goalRewardLabel: UILabel!
    @IBOutlet weak var goalRewardImageView: UIImageView!
    @IBOutlet weak var goalProgressPercentageLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        GoalTableViewController().tableView.rowHeight = UITableView.automaticDimension
        //GoalTableViewController().tableView.estimatedRowHeight = 500
        GoalTableViewController().tableView.estimatedRowHeight = UITableView.automaticDimension
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state

    }
}
