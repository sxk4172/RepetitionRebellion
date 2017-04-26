//
//  AddMissionViewController.swift
//  Repetition Rebellion
//
//  Created by Sean Maraia on 7/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase

class AddMissionViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, modalVCChild {
    @available(iOS 6.0, *)
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addMissionToolCell", for: indexPath) as! MissionToolCollectionViewCell
        
        //if the item at the index is in the selectedIndices array, give it a blue background. Otherwise, give it the white background
        if selectedIndices.index(of: indexPath.row) != nil {
            cell.backgroundColor = UIColor.blue
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        cell.utility = Toolbelt.sharedInstance[indexPath.row]
        
        return cell
    }

    
    @IBOutlet weak var missionTypePicker: UIPickerView!
    @IBOutlet weak var missionDetailTextView: UITextView!
    @IBOutlet weak var missionGoalSlider: UISlider!
    @IBOutlet weak var missionGoalTextLabel: UILabel!
    @IBOutlet weak var missionNameTextField: UITextField!
    @IBOutlet weak var missionToolsCollectionView: UICollectionView!
    @IBOutlet weak var missionEndDatePicker: UIDatePicker!
    
    var modalParent: modalVCParent? = nil
    
    var selectedIndices: [Int] = []
    var selectedKind = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionDetailTextView.delegate = self
        
        missionToolsCollectionView.dataSource = self
        missionToolsCollectionView.delegate = self
        
        missionNameTextField.delegate = self
        
        missionTypePicker.dataSource = self
        missionTypePicker.delegate = self
        
        //setting the date picker's maximum date to be one year away, and the minimum date to be the current date.

        let currentCal = NSCalendar.current
        let yearsToAdd = 1
        var dateComponent = DateComponents()
        dateComponent.year = yearsToAdd
        
        let nextYear = currentCal.date(byAdding: dateComponent, to: Date())
        missionEndDatePicker.minimumDate = NSDate() as Date
        missionEndDatePicker.maximumDate = nextYear
        
        self.missionToolsCollectionView.backgroundColor = UIColor.clear
        self.missionToolsCollectionView.backgroundView = UIView(frame: CGRect.zero)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()

    }
    
    ///update the missionGgoalTextLabel whenever the slider is changed
    @IBAction func sliderValueChanged(sender: AnyObject) {
        missionGoalTextLabel.text = "Goal: \(Int(missionGoalSlider.value))"
    }
    
    @IBAction func CancelTapped(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func DoneTapped(sender: AnyObject) {
        
        //create the new mission with the correct values, and then place it in the Missions singleton
        let newMission = Mission(name: missionNameTextField.text!, kind: selectedKind, details: missionDetailTextView.text, tools: selectedIndices, imp: 0, ending: missionEndDatePicker.date.timeIntervalSinceReferenceDate, points: 0, goal: Int(missionGoalSlider.value))
        let _REF_Users_currentUser_missions = FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/missions")
        var toolsString = ""
        for tool in newMission.tools {
            print("inside loop missions1")
            toolsString += "\(tool)"
        }
        let key = newMission.name+"\(newMission.time_assigned)" + toolsString
        let cleanKey = key.addingPercentEncoding( withAllowedCharacters:(NSCharacterSet.alphanumerics))
       _REF_Users_currentUser_missions.child(byAppendingPath: cleanKey!).setValue(newMission.toDict())
        Missions.sharedInstance.data.append(newMission)

        //call modalDidUnwind on the parent after dismissing this VC.
        dismiss(animated: true, completion: {self.modalParent?.modalDidUnwind(data: nil)})
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        selectedKind = MissionType.types[row].rawValue
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = selectedKind
        view.textAlignment = .center
        return view;
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MissionType.types.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Toolbelt.sharedInstance.count
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
    ///If the itemAtIndexPath is already selected, deselect it; otherwise select it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //if the item at the index is in the selectedIndices array, give it a blue background. Otherwise, give it the white background
        if !selectedIndices.contains(indexPath.row) {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.blue
            selectedIndices.append(indexPath.row)
        } else {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
            if let index = selectedIndices.index(of: indexPath.row) {
                selectedIndices.remove(at: index)
            }
        }
    }
    
}
