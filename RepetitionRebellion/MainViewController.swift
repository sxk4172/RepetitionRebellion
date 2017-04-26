//
//  MainViewController.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 3/24/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        
        let _REF_Users_currentUser = FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)")
        _REF_Users_currentUser.observe(.value, with:{ snapshot in
            if snapshot.hasChild("missions") {
                print("in main view")
                Toolbelt.sharedInstance.initialize()
                Missions.sharedInstance.pullMissionDB() {_ in
                    if Missions.sharedInstance.count <= 1 {
                        Missions.sharedInstance.initialize()
                    }
                    print("pullmissiondb")
                }
            }
            
        })

        
        let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            print("delay")
            alertController.dismiss(animated: true, completion: nil);
            print("alert closed")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
