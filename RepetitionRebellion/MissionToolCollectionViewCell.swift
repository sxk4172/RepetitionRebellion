//
//  MissionToolCollectionViewCell.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 4/12/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit

class MissionToolCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var toolName: UILabel!
    @IBOutlet weak var toolImage: UIImageView!
    var utility: UtilityTool! {
        didSet{
            updateUI()
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: superview!.frame.height * 0.9, height: superview!.frame.height * 0.9)
    }
    
    ///whenever the utility is set, this will be called. Updates toolName and toolImage with the utility's params
    func updateUI() {
        toolName.text = utility.title
        toolImage.image = utility.featuredImage
    }

}
