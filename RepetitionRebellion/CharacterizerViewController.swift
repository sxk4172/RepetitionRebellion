//
//  CharacterizerViewController.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 3/30/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit

class CharacterizerViewController: UIViewController {
    
    var storyBoard: UIStoryboard!
    var detailCharacterizer: UIViewController!
    
    @IBOutlet weak var gooButton: UIButton!
    @IBOutlet weak var ameobaBody: UIButton!
    @IBOutlet weak var humanButton: UIButton!
    @IBOutlet weak var werewolfButton: UIButton!
    @IBOutlet weak var robotButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gooButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        ameobaBody.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        humanButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        robotButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        werewolfButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
