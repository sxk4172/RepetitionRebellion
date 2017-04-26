//
//  EditUtilityScreen.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/26/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import CoreData

var toolIndex = 0

class EditUtilityScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //store image from database in this variable
    var imgg: UIImage!
    var logoImages1: [UIImage] = []
    
    var utility: UtilityTool!

    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var utilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let index = toolIndex
        utility = Toolbelt.sharedInstance[index]
        featuredImage.image = utility.featuredImage
        tabBarController?.navigationItem.title = utility.title
        navigationItem.title = utility.title

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()

    }
  
//    @IBAction func save(_ sender: Any) {
//        let alert = UIAlertController(title: "Save",
//                                      message: "Are you Sure?",
//                                      preferredStyle: .alert)
//        
//        let saveAction = UIAlertAction(title: "Save",
//                                       style: .default,
//                                       handler: { (action:UIAlertAction) -> Void in
//                                        
//                                        
//                                        if self.imgg != nil {
//                                            
//                                            //converting image to NSData
//                                            let img = self.utility.featuredImage
//                                            print(self.utility.featuredImage)
//                                            let imgData = UIImagePNGRepresentation(img!)
//                                            let img1 = self.imgg
//                                            print(self.imgg)
//                                            let img1Data = UIImagePNGRepresentation(img1!)
//                                            do {
//                                                
//                                                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UtilityBeltTools")
//                                                print("blah 1")
//                                                // request.predicate = NSPredicate(format: "utilityImage = %@", imgData!)
//                                                let results = try context.fetch(request)
//                                                print("blah 2")
//
//                                                if results.count>0 {
//                                                    print("blah 3")
//
//                                                    for items in results as! [NSManagedObject]{
//                                                        //look for image in database
//                                                        print("blah 4")
//
//                                                        if let label = items.value(forKey: "utilityImage") as? NSData {
//                                                            print("blah 5")
//
//                                                            if label as Data == imgData! {
//                                                                print("same")
//                                                                items.setValue(img1Data, forKey : "utilityImage")
//                                                            }
//                                                        }
//                                                        do {
//                                                            print("blah 6")
//
//                                                            try context.save()
//                                                        } catch {
//                                                            print("There was an error saving data")
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                            catch{
//                                                print("There was an error saving data 2")
//                                            }
//                                            
//                                            
//                                        }
//                                        
//                                        
//                                        
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .default) { (action: UIAlertAction) -> Void in
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        present(alert,
//                animated: true,
//                completion: nil)
//        
//        
//
//        
//    }

    @IBAction func editImage(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        self.present(pickerController, animated:true , completion:nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        featuredImage.image = selectedImage
        imgg = selectedImage
        utility.featuredImage = selectedImage
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Save",
                message: "Are you Sure?",preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default, handler: { (action:UIAlertAction) -> Void in

        
        Toolbelt.sharedInstance[toolIndex].featuredImage = selectedImage
        Toolbelt.sharedInstance.updateToolsDBItem(item: self.utility)
                                        
        })
                                        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    

}
