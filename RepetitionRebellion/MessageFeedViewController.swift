//
//  MessageFeedViewController.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase
import CoreData



class MessageFeedViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messages = [Message]()
    var users = [Users]()
    var rowIndex: Int = 0
    var messageCounter = [Int:Bool]()
    var username: [String] = []
    
    @IBOutlet weak var messageTableView: UITableView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTableView.reloadData()
        
        //addView.removeFromSuperview()
    }
    
    @IBAction func backbutton(_ sender: Any) {
        print("back pressed")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        self.present(viewController, animated: false, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    var addViewGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hi there")
//        addViewGesture = UITapGestureRecognizer(target: self, action: #selector(removeAddView))
//        addView.layer.borderColor = UIColor.gray.cgColor
//        addView.layer.borderWidth = 1.0
//        addView.layer.cornerRadius = 3.0
//        
//        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Main Menu", style: .plain, target:self, action:#selector(MessageFeedViewController.back))
//        self.navigationItem.leftBarButtonItem = newBackButton;
        
        let _REF_Users_Uid_ALLMessage = FIRDatabase.database().reference(fromURL:"https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/allMessages")
        
        let _PREF_Users_ALLMessage_Username = FIRDatabase.database().reference(fromURL:"https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/messageUsername")
        
        _REF_Users_Uid_ALLMessage.observe(.value, with:{ snapshot in
            self.messages = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    DataService.ds.REF_Messages.observe(.value, with:{ snapshott in
                        
                        if let snapshotss = snapshott.children.allObjects as? [FIRDataSnapshot] {
                            for snapp in snapshotss {
                                if let messageDict = snapp.value as? Dictionary<String, AnyObject> {
                                    let key = snapp.key
                                    if key == snap.key{
                                        
                                        let message = Message(messageKey: key, dictionary: messageDict)
                                        self.messages.append(message)
                                    }
                                    
                                }
                            }
                        }
                        self.messageTableView.reloadData()
                        
                    })
                    
                    
                }
            }
        })
        
        //get username
        
        _PREF_Users_ALLMessage_Username.observe(.value, with:{ snapshott in
            self.users = []
            if let snapshotss = snapshott.children.allObjects as? [FIRDataSnapshot] {
                for snapp in snapshotss {
                    if let messageDict = snapp.value as? Dictionary<String, AnyObject> {
                        let usersN = Users(userKey: snapp.key, dictionary: messageDict)
                        self.users.append(usersN)
                        
                    }
                }
            }
            self.messageTableView.reloadData()
            
        })
        
        
        messageTableView.reloadData()
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.leftBarButtonItems = []
    }
    
    
    
//    func addTapped() {
//        addView.sizeToFit()
//        addView.frame = CGRect(x: 0, y: -addView.frame.height/2.0 - 20, width: view.frame.width, height: addView.frame.height)
//        view.addSubview(addView)
//        view.addGestureRecognizer(addViewGesture)
//        addView.alpha = 0.0
//        UIView.animate(withDuration: 0.25, animations: {
//            self.addView.frame = CGRect(x: 0, y: self.addView.frame.height/2.0 - 20, width: self.view.frame.width, height: self.addView.frame.height)
//            self.addView.alpha = 1.0
//        })
//    }
//    
//    func removeAddView(sender: UITapGestureRecognizer) {
//        
//        UIView.animate(withDuration: 0.25, animations: {
//            self.addView.frame = CGRect(x: 0, y: -self.addView.frame.height/2.0 - 20, width: self.view.frame.width, height: self.addView.frame.height)
//            self.addView.alpha = 0.0
//        })
//        view.removeGestureRecognizer(addViewGesture)
//    }
//
    
    func back() {
        self.performSegue(withIdentifier: SEGUE_Communicatior, sender: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        print(indexPath.row)
        let usersN = users.reversed()[indexPath.row]
        
        let message = messages.reversed()[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as?  MessageCellTableViewCell{
            cell.configureCell(message: message)
            cell.configure(usern: usersN)
            cell.backgroundColor = .clear
            return cell
        }
        else {
            return MessageCellTableViewCell()
        }
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        rowIndex = indexPath.row
        usernFullmessage = users.reversed()[rowIndex]
        messageFullMessage = messages.reversed()[rowIndex]
        let viewController = UIStoryboard(name: "CommunicatorStory", bundle: nil).instantiateViewController(withIdentifier: "fullMessageViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    
    
}
