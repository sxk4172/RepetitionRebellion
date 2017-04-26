//
//  TextJournal.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/4/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase

class TextJournal: UIViewController, UITextFieldDelegate {


    @IBAction func saveButton(_ sender: Any) {
        if let journalN = journalName.text, journalN != "", let journalC = journalContent.text, journalC != "" {
            
            let journalNametxt: Dictionary<String, AnyObject> = [
                "journalName": journalName.text! as AnyObject
            ]
            
            let journalContenttxt: Dictionary<String, AnyObject> = [
                "journalContent": journalContent.text! as AnyObject
            ]
            
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.string(from: date as Date)
            
            let journalDatetxt: Dictionary<String, AnyObject> = [
                "journalDate": date1String as AnyObject
            ]
            
            let firebasePost = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalName")
            let firebasePostReference = firebasePost.childByAutoId()
            firebasePostReference.setValue(journalNametxt)
            
            let firebasePost1 = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalContent")
            let firebasePostReference1 = firebasePost1.childByAutoId()
            firebasePostReference1.setValue(journalContenttxt)
            
            let firebasePost2 = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalDate")
            let firebasePostReference2 = firebasePost2.childByAutoId()
            firebasePostReference2.setValue(journalDatetxt)
            
            showAlert(title: "Journal Status", msg: "Saved!")
            
            
        }
        else {
            showErrorAlert(title: "Fill Required Fields", msg: "Enter Name and Content")
            
        }

    }
    
    @IBOutlet weak var journalName: UITextField!
    
    @IBOutlet weak var journalContent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        journalName.delegate = self
        journalContent.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func showAlert (title: String, msg: String) {
        print("inside show alert")
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        journalName.text = ""
        journalContent.text = ""
        
    }
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
}
