//
//  CharacterizerDetailViewController.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 3/30/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit

var buttonSelected: String!

class CharacterizerDetailViewController: UIViewController {
    @IBOutlet weak var ameobaEyes: UIImageView!
    @IBOutlet weak var ameobaMouth: UIImageView!
    @IBOutlet weak var ameobaBody: UIImageView!
    @IBOutlet weak var ameobaEye2: UIButton!
    @IBOutlet weak var ameobaEye3: UIButton!
    @IBOutlet weak var ameobaMouth1: UIButton!
    @IBOutlet weak var ameobaMouth2: UIButton!
    @IBOutlet weak var ameobaMouth3: UIButton!
    @IBOutlet weak var ameobaEye1: UIButton!
    
    @IBAction func ameobaEye2(_ sender: Any) {
//        if buttonSelected == "blue" {
//            ameobaEyes.image = UIImage(named: "Amoeba_Blue_Eyes_2.png")
//        }
//        else if buttonSelected == "yellow"{
//            ameobaEyes.image = UIImage(named: "Amoeba_Yellow_Eyes_2.png")
//        }
//        else if buttonSelected == "green"{
//            ameobaEyes.image = UIImage(named: "Amoeba_Green_Eyes_3.png")
//        }
//        else{
        ameobaEyes.image = UIImage(named: "Amoeba_White_Eyes_2.png")
 //       }
    }
    @IBAction func backPressed(_ sender: Any) {
        
        print("back pressed")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        self.present(viewController, animated: false, completion: nil)
        
    }
    @IBAction func ameobaEye1(_ sender: Any) {
//        if buttonSelected == "blue" {
//            ameobaEyes.image = UIImage(named: "Amoeba_Blue_Eyes_1.png")
//        }
//        else if buttonSelected == "yellow"{
//            ameobaEyes.image = UIImage(named: "Amoeba_Yellow_Eyes_1.png")
//        }
//        else if buttonSelected == "green"{
//            ameobaEyes.image = UIImage(named: "Amoeba_Green_Eyes_1.png")
//        }
//        else{
            ameobaEyes.image = UIImage(named: "Amoeba_White_Eyes_1.png")
       // }
    }
    @IBAction func ameobaEye3(_ sender: Any) {
//        if buttonSelected == "blue" {
//            ameobaEyes.image = UIImage(named: "Amoeba_Blue_Eyes_3.png")
//        }
//        else if buttonSelected == "yellow"{
//            ameobaEyes.image = UIImage(named: "Amoeba_Yellow_Eyes_3.png")
//        }
//        else if buttonSelected == "green"{
//            ameobaEyes.image = UIImage(named: "Amoeba_Green_Eyes_3.png")
//        }
//        else{
            ameobaEyes.image = UIImage(named: "Amoeba_White_Eyes_3.png")
     //   }
    }
    @IBAction func ameobaMouth1(_ sender: Any) {
//        if buttonSelected == "blue" {
//            ameobaMouth.image = UIImage(named: "Amoeba_Blue_Mouth_1.png")
//        }
//        else if buttonSelected == "green"{
//            ameobaMouth.image = UIImage(named: "Amoeba_Green_Mouth_1.png")
//        }
//        else if buttonSelected == "yellow"{
//            ameobaMouth.image = UIImage(named: "Amoeba_Yellow_Mouth_1.png")
//        }
//        else{
            ameobaMouth.image = UIImage(named: "Amoeba_White_Mouth_1.png")
   //     }
    }
    @IBAction func ameobaMouth2(_ sender: Any) {
//        if buttonSelected == "blue" {
//            ameobaMouth.image = UIImage(named: "Amoeba_Blue_Mouth_2.png")
//        }
//        else if buttonSelected == "green"{
//            ameobaMouth.image = UIImage(named: "Amoeba_Green_Mouth_2.png")
//        }
//        else if buttonSelected == "yellow"{
//            ameobaMouth.image = UIImage(named: "Amoeba_Yellow_Mouth_1.png")
//        }
//        else{
            ameobaMouth.image = UIImage(named: "Amoeba_White_Mouth_2.png")
//        }

    }
    @IBAction func ameobaMouth3(_ sender: Any) {
//        if buttonSelected == "blue" {
//            ameobaMouth.image = UIImage(named: "Amoeba_Blue_Mouth_3.png")
//        }
//        else if buttonSelected == "green"{
//            ameobaMouth.image = UIImage(named: "Amoeba_Green_Mouth_1.png")
//        }
//        else if buttonSelected == "yellow"{
//            ameobaMouth.image = UIImage(named: "Amoeba_Yellow_Mouth_3.png")
//        }
//        else{
            ameobaMouth.image = UIImage(named: "Amoeba_White_Mouth_3.png")
//        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSelected = ""
        print(buttonSelected)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func orange(_ sender: Any) {
    }
    @IBAction func yellow(_ sender: Any) {
        buttonSelected = "yellow"
        ameobaMouth.image = UIImage(named: "Amoeba_Yellow_Mouth_1.png")
        ameobaEyes.image = UIImage(named: "Amoeba_Yellow_Eyes_1.png")
        ameobaBody.image = UIImage(named: "Amoeba_Yellow_Body.png")
        ameobaEye1.setImage(UIImage(named:"Amoeba_Yellow_Eyes_1.png"), for: UIControlState.normal)
        ameobaEye2.setImage(UIImage(named:"Amoeba_Yellow_Eyes_2.png"), for: UIControlState.normal)
        ameobaEye3.setImage(UIImage(named:"Amoeba_Yellow_Eyes_3.png"), for: UIControlState.normal)
        ameobaMouth1.setImage(UIImage(named:"Amoeba_Yellow_Mouth_1.png"), for: UIControlState.normal)
        ameobaMouth2.setImage(UIImage(named:"Amoeba_Yellow_Mouth_2.png"), for: UIControlState.normal)
        ameobaMouth3.setImage(UIImage(named:"Amoeba_Yellow_Mouth_3.png"), for: UIControlState.normal)
    }
    @IBAction func blue(_ sender: Any) {
        buttonSelected = "blue"
        ameobaMouth.image = UIImage(named: "Amoeba_Blue_Mouth_1.png")
        ameobaEyes.image = UIImage(named: "Amoeba_Blue_Eyes_1.png")
        ameobaBody.image = UIImage(named: "Amoeba_Blue_Body.png")
        ameobaEye1.setImage(UIImage(named:"Amoeba_Blue_Eyes_1.png"), for: UIControlState.normal)
        ameobaEye2.setImage(UIImage(named:"Amoeba_Blue_Eyes_2.png"), for: UIControlState.normal)
        ameobaEye3.setImage(UIImage(named:"Amoeba_Blue_Eyes_3.png"), for: UIControlState.normal)
        ameobaMouth1.setImage(UIImage(named:"Amoeba_Blue_Mouth_1.png"), for: UIControlState.normal)
        ameobaMouth2.setImage(UIImage(named:"Amoeba_Blue_Mouth_2.png"), for: UIControlState.normal)
        ameobaMouth3.setImage(UIImage(named:"Amoeba_Blue_Mouth_3.png"), for: UIControlState.normal)
    }
    @IBAction func green(_ sender: Any) {
        buttonSelected = "green"
        ameobaMouth.image = UIImage(named: "Amoeba_Green_Mouth_1.png")
        ameobaEyes.image = UIImage(named: "Amoeba_Green_Eyes_1.png")
        ameobaBody.image = UIImage(named: "Amoeba_Green_Body.png")
        ameobaEye1.setImage(UIImage(named:"Amoeba_Green_Eyes_1.png"), for: UIControlState.normal)
        ameobaEye2.setImage(UIImage(named:"Amoeba_Green_Eyes_2.png"), for: UIControlState.normal)
        ameobaEye3.setImage(UIImage(named:"Amoeba_Green_Eyes_3.png"), for: UIControlState.normal)
        ameobaMouth1.setImage(UIImage(named:"Amoeba_Green_Mouth_1.png"), for: UIControlState.normal)
        ameobaMouth2.setImage(UIImage(named:"Amoeba_Green_Mouth_2.png"), for: UIControlState.normal)
        ameobaMouth3.setImage(UIImage(named:"Amoeba_Green_Mouth_3.png"), for: UIControlState.normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    //2
     func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    //3
     func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ameobaMouth",
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
}
