//
//  UtilityTool.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/24/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData

var logoImages: [UIImage] = []


/// A singleton that contains an array of UtilityTool structs.
///
/// - SeeAlso: `UtilityTool`
class Toolbelt {
    static let sharedInstance = Toolbelt()
    
    var data: [UtilityTool] = []
    private init () {}
    
    /// Allows for bracket notation to directly access the data array.
    subscript (index: Int) -> UtilityTool {
        get{
            return data[index]
        }
        
        set(newValue){
            data[index] = newValue
        }
    }
    
    /// Returns the count of Mission's data array
    var count: Int {
        return data.count
    }
    
    /// Fills the data array with dummy data.
    /// For use to populate the data array for the first time
    func initialize() {
        logoImages.removeAll()
        var arrayOfImages: [String] = []
        let listRef = Bundle.main.path(forResource: "ToolList", ofType: "plist")
        if let arrayOfObjects =  NSArray(contentsOfFile: listRef!){
            arrayOfImages = arrayOfObjects.map({(object) -> String in
                return object as! String
            })
        }
        
        for name in arrayOfImages {
            logoImages.append(UIImage(named: name)!)
        }
        
        data = [
            UtilityTool(title: "Laser Pistol", description: "Damage the Imp, then cool down your pistol by using your breathing exercises", featuredImage: logoImages[0 % logoImages.count]),
            UtilityTool(title: "Sword of Swiftness", description: "Walk quickly past the problem", featuredImage: logoImages[1 % logoImages.count]),
            UtilityTool(title: "Goggles", description: "Close your eyes and picture your safe place", featuredImage: logoImages[2 % logoImages.count]),
            UtilityTool(title: "Gauntlet", description: "Helps you fight the Imp with strong gloves", featuredImage: logoImages[3 % logoImages.count]),
            UtilityTool(title: "Kite", description: "It's a kite", featuredImage: logoImages[4 % logoImages.count])
        ]
        updateToolsDB()
        
        
        
    }
    
    /// Pushes the data array to the Firebase Realtime Database entry for the user's UtilityTool.
    func updateToolsDB() {
        //set tools on Firebase to this value
        let _REF_Users_currentUser_tools = FIRDatabase.database().reference(fromURL:"https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/tools")
        for tool in data {
            _REF_Users_currentUser_tools.child(byAppendingPath: tool._toolKey).setValue(tool.toDict())
        }
        
        
    }
    
    func updateToolsDBItem(item: UtilityTool) {
        if let key = item._toolKey{
           FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/tools").child(byAppendingPath: key).updateChildValues(item.toDict())
        }
    }
    
    
    /// Sets the data array to match the data for the current user's Tools array on Firebase.
    /// - parameter completion: A block of code guaranteed to execute once the data array has been updated.
    func pullFromDB(completion: ((_ succeeded: Bool) -> Void)? = nil) {
        data = []
        let toolbeltRef = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/tools")
            toolbeltRef.observe(.value, with: {snapshot in
                if let allTools = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for tool in allTools {
                        if let toolDict = tool.value as? Dictionary<String, AnyObject> {
                            let key = tool.key
                            let tool = UtilityTool(toolKey: key, dictionary:  toolDict)
                            self.data.append(tool)
                        }
                    }
                    
                }
                completion?(true)
            })
        
    }
    
}


/// A struct containing the data of a UtilityTool, matching the schema of the Firebase Databse
struct UtilityTool: Equatable {
    var title = ""
    var description = ""
    var featuredImage: UIImage!
    
     var _toolKey: String!
    
    init (title: String, description: String, featuredImage: UIImage!) {
        self.title = title
        self.description = description
        let key = title + description
        let cleanKey = key.addingPercentEncoding(withAllowedCharacters:(NSCharacterSet.alphanumerics))
        self._toolKey = cleanKey
        self.featuredImage = featuredImage
        
    }
    
    init(toolKey: String, dictionary: Dictionary<String,AnyObject>) {
        self._toolKey = toolKey
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        if let description = dictionary["desc"] as? String {
            self.description = description
        }
        if let imageData = dictionary["img"] as? String {
            let dataDecoded: NSData = NSData(base64Encoded: imageData, options: .ignoreUnknownCharacters)!
            
            self.featuredImage = UIImage(data:dataDecoded as Data)
        }
    }
    
    ///Creates a dictionary for the UtilityTool
    /// - returns: A Dictionary of strings for the UtilityTool's variables:
    ///     - title: String
    ///     - desc: String
    ///     - img: String
    func toDict() -> Dictionary<String, Any> {
        var dict = Dictionary<String, Any>()
        dict["title"] = title
        dict["desc"] = description
        let imageData:NSData = UIImagePNGRepresentation(featuredImage)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
       // let dataDecoded : Data = Data(base64Encoded: strBase64, options: .ignoreUnknownCharacters)!
        //let decodedimage = UIImage(data: dataDecoded)
        dict["img"] = strBase64
        return dict
    }
    
}

func ==(lhs: UtilityTool, rhs: UtilityTool) -> Bool {
    return lhs._toolKey == rhs._toolKey && lhs.featuredImage == rhs.featuredImage && lhs.title == rhs.title && lhs.description == rhs.description
}
