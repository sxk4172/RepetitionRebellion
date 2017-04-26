//
//  AddToolViewController.swift
//  Repetition Rebellion
//
//  Created by Sean Maraia on 7/19/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddToolViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, modalVCChild, UINavigationControllerDelegate {
    
    @IBOutlet weak var toolNameTextField: UITextField!
    @IBOutlet weak var toolLabelTextField: UITextField!
    @IBOutlet weak var toolImageView: UIImageView!
    @IBOutlet weak var containingViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containingViewTopConstraint: NSLayoutConstraint!
    
    var keyboardSize: CGRect?
    var activeTextField: UITextField? = nil
    
    var modalParent: modalVCParent? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolNameTextField.delegate = self
        toolNameTextField.tag = 0
        
        toolLabelTextField.delegate = self
        toolLabelTextField.tag = 1
        
        let imageTapped = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        toolImageView.isUserInteractionEnabled = true
        toolImageView.addGestureRecognizer(imageTapped)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(sender: AnyObject) {
        
        if let nameText = toolNameTextField.text, let labelText = toolLabelTextField.text, let image = toolImageView.image {
            if(nameText.characters.count > 0 && labelText.characters.count > 0) {
                let newTool = UtilityTool(title: nameText, description: labelText, featuredImage: image)
                
                Toolbelt.sharedInstance.data.append(newTool)
                Toolbelt.sharedInstance.updateToolsDBItem(item: newTool)
                unwindModal()
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    ///Displays a UIImagePickerController when the tool image is tapped
    func handleImageTap() {
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.modalPresentationStyle = UIModalPresentationStyle.popover
        //can change the selected area to show
        pickerController.allowsEditing = true
        pickerController.delegate = self
        //only images are allowed
        pickerController.mediaTypes = [kUTTypeImage as String]
        
        //if using an iPad, show the picker as a popover. This is REQUIRED in order to have an image picker on an iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerController.modalPresentationStyle = .popover
            pickerController.popoverPresentationController!.sourceView = view
            pickerController.popoverPresentationController!.sourceRect = toolImageView.bounds
        }
        self.present(pickerController, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //get the image from the info Dictionary that is provided, and make it the new toolImageView
        toolImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        toolImageView.contentMode = .scaleAspectFit
        picker.dismiss(animated: true, completion: nil)
    }
    
    ///pushes the view up to make room for the keyboard if the currently active textField would be covered by it.
    func keyboardWasShown(notification: NSNotification){
        //get the keyboardSize and duration of the animation from the userInfo dictionary
        var userInfo : Dictionary = (notification as NSNotification).userInfo!
        keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //if activeTextField is not nil, and the activeTextField's frame would be covered by the keyboard
        if self.activeTextField != nil && self.view.convert(self.activeTextField!.frame, from: self.activeTextField).minY > (self.keyboardSize?.minY)! {
            //animate these changes over the duration of the keyboard animation
            UIView.animate(withDuration: duration, animations: {
                
                //change the containingView top and bottom constraints to the height of the keyboard, and layout the view.
                //This will push the entire view upward, so it appears the keyboard is pushing the view upwards
                self.containingViewBottomConstraint.constant = (self.keyboardSize?.height)!
                self.containingViewTopConstraint.constant = -(self.keyboardSize?.height)!
                self.view.layoutIfNeeded()
                
            })
        }
        
        
    }
    
    //MARK: Methods to allow keyboard to push the view out of the way if necessary
    
    ///sets the activeTextField to the textField that is edited
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    ///sets the activeTextField to nil
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
    }
    
    ///pushes the view down to normal
    func keyboardWasHidden(notification: NSNotification){
        //if the keyboard previously pushed the view upward
        if containingViewTopConstraint.constant != 0 && containingViewBottomConstraint.constant != 0{
            
            //get the duration of the animation from the userInfo Dictionary
            var userInfo : Dictionary = (notification as NSNotification).userInfo!
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            //animate the following changes with the duration
            UIView.animate( withDuration: duration, animations: {
                //set the containingView top and bottom constraints to the normal 0 value, and layout the view
                //This returns the view to the normal value without the keyboard
                self.containingViewBottomConstraint.constant = 0
                self.containingViewTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    ///allows for the return key to cause the next textField to be selected
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //if there is another textField that can be selected, make it the firstResponder. Otherwise, resignFirstResponder, which will dismiss the keyboard
        if let next = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            next.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //add the observers to that keyboardWasShown and keyboardWasHidden are called when they should be
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //remove the observers to that keyboardWasShown and keyboardWasHidden aren't called on the next VCs
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        super.viewWillDisappear(animated)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
