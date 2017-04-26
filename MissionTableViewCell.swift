//
//  MissionTableViewCell.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 4/12/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit

class MissionTableViewCell: UITableViewCell {

    @IBOutlet weak var missionNameLabel: UILabel!
    
    @IBOutlet weak var impImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
