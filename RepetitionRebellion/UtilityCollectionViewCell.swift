//
//  UtilityCollectionViewCell.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/24/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit

class UtilityCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var utilityDescription: UILabel!
    
    @IBOutlet weak var utlityLabel: UILabel!
    
    @IBOutlet weak var featuredImage: UIImageView!
    
    var utility: UtilityTool! {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        utlityLabel.text = utility.title
        //featuredImage.image! = utility.featuredImage
        utilityDescription.text = utility.description
    }
    
}
