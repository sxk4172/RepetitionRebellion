//
//  SendMessage.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase


class SendMessage: UIViewController , UITextFieldDelegate {
    
    
    var temp = true
    var temp1 = true
    
    let prefs = UserDefaults.standard
    
    @IBOutlet weak var sendToUser: UITextField!
    
    @IBOutlet weak var sendTextMessage: UITextField!
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        if let sendUser = sendToUser.text, sendUser != "", let tMessage = sendTextMessage.text, tMessage != "" {
            
            print("here")
            
            let AES = CryptoJS.AES()
            let encrypted = AES.encrypt(sendTextMessage.text!, password: "password123")
            
            let mess: Dictionary<String, AnyObject> = [
                "textMessage": encrypted as AnyObject
            ]
            
            let usersname: Dictionary<String,AnyObject> = [
                "username": UserDefaults.standard.value(forKey: "USERNAMEID")! as AnyObject
            ]
            
            let firebasePost = DataService.ds.REF_Messages.childByAutoId()
            firebasePost.setValue(mess)
            
            
            //current user
            let _REF_Users_Uid_ALLMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/allMessages")
            
            let userMessRef = _REF_Users_Uid_ALLMessage.child(byAppendingPath: firebasePost.key)
            userMessRef.observeSingleEvent(of: .value, with: { snapshot in
                if (snapshot.value as? NSNull) != nil{
                    userMessRef.setValue(true)
                }
                
            })
            
            let _REF_Users_Uid_sentMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey:KEY_ID)!)/messageSent")
            
            let userMessSentRef = _REF_Users_Uid_sentMessage.child(byAppendingPath: firebasePost.key)
            userMessSentRef.observeSingleEvent(of: .value, with: { snapshot in
                if (snapshot.value as? NSNull) != nil{
                    userMessSentRef.setValue(true)
                }
                
            })
            
            
            let users: Dictionary<String,AnyObject> = [
                //  "username": NSUserDefaults.standardUserDefaults().valueForKey("USERNAMEID")!
                "username": "Me" as AnyObject
            ]
            
            let _PREF_Users_ALLMessage_Username = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/messageUsername")
            
            let usernameMessRef = _PREF_Users_ALLMessage_Username.childByAutoId()
            usernameMessRef.setValue(users)
            
            //receiver user
            
            DataService.ds.REF_Users.observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots {
                        if let usersDict = snap.value as? Dictionary<String, AnyObject> {
                            let userN = Users(userKey: snap.key, dictionary: usersDict)
                            if self.sendToUser.text!.uppercased() == userN.username {
                                
                                let key = snap.key
                                let _REF_ReceiveUsers_Uid_ALLMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(key)/allMessages")
                                
                                let receiveuserMessRef = _REF_ReceiveUsers_Uid_ALLMessage.child(byAppendingPath: firebasePost.key)
                                receiveuserMessRef.observeSingleEvent(of: .value, with: { snapshot in
                                    if (snapshot.value as? NSNull) != nil{
                                        receiveuserMessRef.setValue(true)
                                    }
                                    
                                })
                                
                                let _REF_receiveUsers_Uid_receiveMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(key)/messageReceived")
                                
                                let receiveuserMessSentRef = _REF_receiveUsers_Uid_receiveMessage.child(byAppendingPath: firebasePost.key)
                                receiveuserMessSentRef.observeSingleEvent(of: .value, with: { snapshot in
                                    if (snapshot.value as? NSNull) != nil{
                                        receiveuserMessSentRef.setValue(true)
                                    }
                                    
                                })
                                
                                let _PREF_UsersReceive_ALLMessage_Username = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(key)/messageUsername")
                                
                                let usernameMessReceive = _PREF_UsersReceive_ALLMessage_Username.childByAutoId()
                                usernameMessReceive.observeSingleEvent(of: .value, with: { snapshot in
                                    if (snapshot.value as? NSNull) != nil{
                                        // print("bool:\(self.temp)")
                                        if(self.temp == true) {
                                            usernameMessReceive.setValue(usersname)
                                            self.temp = false
                                            self.showAlert(title: "Message Status", msg: "Message Sent!")
                                            //print("bool1:\(self.temp)")
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                
                
            })
        }
            
        else {
            showErrorAlert(title: "Fill Required Fields", msg: "Enter Name and Message")
        }
        
    }
    
    func showAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        sendToUser.text = ""
        sendTextMessage.text = ""
        
    }
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendToUser.delegate = self
        sendTextMessage.delegate = self
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    
}
