//
//  MoodRecordTableViewCell.swift
//  Moody
//
//  Created by Peyton Gasink on 8/1/20.
//  Copyright © 2020 Peyton Gasink. All rights reserved.
//

import UIKit

class MoodRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
