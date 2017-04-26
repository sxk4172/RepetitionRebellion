//
//  Journal.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/4/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase

var journalName = [Users]()
var journalContent = [Users]()
var journalDate = [Users]()
var journalRowIndex: Int = 0

class Journal: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet var addView: UIVisualEffectView!
    
    @IBAction func backPressed(_ sender: Any) {
        print("back pressed")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        
       // addView.removeFromSuperview()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // tabBarController?.navigationItem.leftBarButtonItems = []
    }
    
  //  var addViewGesture : UITapGestureRecognizer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        addViewGesture = UITapGestureRecognizer(target: self, action: #selector(removeAddView))
//        addView.layer.borderColor = UIColor.grayColor().CGColor
//        addView.layer.borderWidth = 1.0
//        addView.layer.cornerRadius = 3.0
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //receive content from firebase
        
        let _journalName = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalName")
        
        _journalName.observe(.value, with:{ snapshott in
            journalName = []
            if let snapshotss = snapshott.children.allObjects as? [FIRDataSnapshot] {
                for snapp in snapshotss {
                    if let messageDict = snapp.value as? Dictionary<String, AnyObject> {
                        let usersN = Users(userKey: snapp.key, dictionary: messageDict)
                        journalName.append(usersN)
                    }
                }
            }
        })
        let _journalContent = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalContent")
        
        _journalContent.observe(.value, with:{ snapshott in
            journalContent = []
            if let snapshotss = snapshott.children.allObjects as? [FIRDataSnapshot] {
                for snapp in snapshotss {
                    if let messageDict = snapp.value as? Dictionary<String, AnyObject> {
                        let usersN = Users(userKey: snapp.key, dictionary: messageDict)
                        journalContent.append(usersN)
                    }
                }
            }
        })
        
        let _journalDate = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalDate")
        
        _journalDate.observe(.value, with:{ snapshott in
            journalDate = []
            if let snapshotss = snapshott.children.allObjects as? [FIRDataSnapshot] {
                for snapp in snapshotss {
                    if let messageDict = snapp.value as? Dictionary<String, AnyObject> {
                        let usersN = Users(userKey: snapp.key, dictionary: messageDict)
                        journalDate.append(usersN)
                        
                    }
                }
            }
            
        })
        

        tableView.reloadData()
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(journalName.count)
        return journalName.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //set data obtained from firebase into the cell
        let journalN = journalName.reversed()[indexPath.row]
        let journalC = journalContent.reversed()[indexPath.row]
        let journalD = journalDate.reversed()[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell") as?  JounalTableViewCell {
            cell.configure(journaln: journalN)
            cell.configure(journaln: journalC)
            cell.configure(journaln: journalD)
            cell.backgroundColor = .clear
            return cell
        }
        else {
            return JounalTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        journalRowIndex = indexPath.row
        self.performSegue(withIdentifier: SEGUE_Journal, sender: nil)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()

    }
   

}
