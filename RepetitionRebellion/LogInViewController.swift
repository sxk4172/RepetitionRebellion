//
//  LogInViewController.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

var usernameField = ""

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    var transitionManager: TransitionManager!

    var countLogin = 0
    
    @IBOutlet weak var containingViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containingViewTopConstraint: NSLayoutConstraint!
    
    var keyboardSize: CGRect?
    
    @IBAction func LogIn(sender: AnyObject) {
        if let email = emailAddress.text, email != "" , let pwd = password.text, pwd != "" , let userN = username.text, userN != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email, password:pwd, completion:{(user, error) in
                if error != nil{
                    let code = (error! as NSError).code
                    print(code)
                    if code == STATUS_USER_NONEXIST {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion:{(user, error) in
                            if error != nil {
                                print(error!)
                                self.showErrorAlert(title: "Could not create an account", msg: "Try something else")
                            }
                            else {
                                
                                print("create user")

                                
                                UserDefaults.standard.setValue(user?.uid, forKey: KEY_ID)
                                
                                
                                let _REF_Users_currentUser = FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)")
                                
                                let usernameUpper = self.username.text!.uppercased()
                                _REF_Users_currentUser.child(byAppendingPath: "username").setValue(usernameUpper)
                                usernameField = usernameUpper
                            
                                UserDefaults.standard.setValue(usernameField, forKey: "USERNAMEID")
                                
                                let _REF_Users_currentUser1 = FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)")
                                _REF_Users_currentUser1.observe(.value, with:{ snapshot in
                                    if !snapshot.hasChild("missions") && self.countLogin == 0{

                                        Toolbelt.sharedInstance.initialize()
                                        Toolbelt.sharedInstance.updateToolsDB()
                                        Missions.sharedInstance.initialize()
                                        Missions.sharedInstance.updateMissionsDB()
                                        self.countLogin = self.countLogin + 1

                                    }
                                    
                                })

                                print("segue")
                                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)

                            }
                            
                        })
                        

                    }
                    else {
                        self.showErrorAlert(title: "Could not create", msg: "Pass or Email Incorrect")
                    }
                }
                    
                else {
                    print("here")
                    UserDefaults.standard.setValue(user!.uid, forKey: KEY_ID)
                    usernameField = self.username.text!.uppercased()
                    UserDefaults.standard.setValue(usernameField, forKey: "USERNAMEID")
                    self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                    
                    
                }
            })
            
        }else {
            showErrorAlert(title: "Credentials Required", msg: "Enter Email, Password and Username")
        }
        
    }
    
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.delegate = self
        password.delegate = self
        username.delegate = self
        
        emailAddress.tag = 1
        password.tag = 2
        username.tag = 3
        
//        //transitions away from this VC will be animated by the FadeTransitionAnimation, just cross fading instead of the normal slide over
//        transitionManager = TransitionManager(transitionAnimation: FadeTransitionAnimation())
//        navigationController?.delegate = transitionManager
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //make the delegate for destinations the same transitionManager for the fadeAnimation
//        segue.destination.transitioningDelegate = transitionManager
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: KEY_ID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
        }
    }


}
