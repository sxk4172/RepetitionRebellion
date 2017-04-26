//
//  Imp.swift
//  Repetition Rebellion
//
//  Created by Stephen Jacobs on 2/5/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
import UIKit

// The class for each 'Page' of the characterizer. Plan to replace with UITabView
class Page {
    var name: String
    var contents: Array<String>
    init(name: String, contents: Array<String>){
        self.name = name
        self.contents = contents
    }
}

// A class that helps link various buttons/items to a characterizer part category and setting
// ex. ("humanoid" "mouth" 1) = the mouth is set to the image ending in 1 or the color at index 1
class PartInfo{
    var category = ""
    var subtype = ""
    var index = -1
    init(category: String, subtype: String, index: Int){
        self.category = category
        self.subtype = subtype
        self.index = index
    }
}


// Represents the data and display for the player-made Imp while it is being created in the characterizer
class Imp {
    //Which characterizer folders each kind should search, and the pages they should be sorted into - eventually will move to Json
    let parts = [
        "humanoid":["eyes", "mouths",    "noses", "brows", "hair", "ears"],
        "human":["torsos", "legs", "feet", "hands"],
        "goblin":["feet", "hands"],
        "amoeba":["eyes", "mouths"],
        "blob":["eyes", "mouths"]]
    
    let pages = [
        "human":[
            Page(name:"eyes and ears", contents:["eyes", "ears"]),
            Page(name:"face", contents:["noses", "mouths"]),
            Page(name:"hair", contents:["brows", "hair"]),
            Page(name:"torso", contents:["torsos", "hands"]),
            Page(name:"legs", contents:["legs", "feet"]),
        ],
        "goblin":[
            Page(name:"eyes and ears", contents:["eyes", "ears"]),
            Page(name:"face", contents:["noses", "mouths"]),
            Page(name:"hair", contents:["brows", "hair"]),
            Page(name:"torso", contents:["hands"]),
            Page(name:"legs", contents:["feet"]),
        ],
        "amoeba":[
            Page(name:"face", contents:["eyes", "mouths"]),
        ],
        "blob":[
            Page(name:"face", contents:["eyes", "mouths"]),
        ]
    ]
    
    //The part categories each kind needs
    //some kinds have to draw from more than one part list.
    // ex. A human needs the parts from both human and humanoid.
    let types = ["human":["human","humanoid"],
        "goblin":["goblin", "humanoid"],
        "amoeba":["amoeba"],
        "blob":["blob"]]
    
    // Images that are not modifiable, and are always displayed for their kind
    // Most kinds have only one base
    // but the goblin is not finished, its torso and legs are placeholder
    // so we need to keep them in a list and draw them all.
    let bases = ["human":["humanoid-head"],
        "goblin":["humanoid-head", "goblin-color", "goblin-line"],
        "amoeba":["amoeba"],
        "blob":["blob"]]
    
    // How many customizer items the base should be in front of
    // in other words, the visible 'layer' it is on, back-to-front
    let baseIndex = ["human":3,
        "goblin":1,
        "amoeba":0,
        "blob":0]
    
    //The current image number for each part
    var currentParts = [String : [String : Int]]()
    //The current selected button for each part
    var currentButtons = [String : [String : UIButton]]()
    //The current color for each part
    var currentColors = [String : [String : UIColor]]()
    //The ImageView used to display each part
    var currentImageViews = [String : [String : UIImageView]]()
    
    //The kind of imp; Human, Goblin, Amoeba, Blob, etc.
    var kind: String
    //Has setup been completed?
    var setUp = false
    
    init(kind: String){
        self.kind = kind
        
        //set up current parts using only types specified
        //set up current imageviews using only types specified
        //set up current colors to all white
        for typ in types[kind]!{
            currentParts[typ] = [String: Int]()
            currentButtons[typ] = [String: UIButton]()
            currentImageViews[typ] = [String: UIImageView]()
            currentColors[typ] = [String: UIColor]()
            for subtype in parts[typ]!{
                currentParts[typ]![subtype] = 0
                currentButtons[typ]![subtype] = UIButton()
                currentImageViews[typ]![subtype] = UIImageView()
                currentColors[typ]![subtype] = UIColor.white
            }
        }
        
    }
    
    //Refreshes the full size image to match the desired button, recolors it to match the current set color,
    // ensures the current button and image number is set to the button sent and its number,
    // and then reorders the imp layers so nothing is out of place.
    func partSelected(part: PartInfo, button: UIButton, view: Characterizer) -> Bool{
        //let image = sender.backgroundImageForState(.Normal)
        var image = UIImage(named: "parts/"+part.category+"-"+part.subtype+"/char-pieces-"+String(part.index))
        
        if image == nil {return false}
        image = image!.imageWithColor(color1: currentColors[part.category]![part.subtype]!, mode: .multiply)
        
        //replace old image with new one
        currentImageViews[part.category]![part.subtype]?.image = image
        
        if part.category == "amoeba"  && part.subtype == "eyes"{
          currentImageViews[part.category]![part.subtype]?.frame = CGRect(x: (displaywidth/2)-20, y:140, width: 70, height: 40)
        }
        else if part.category == "amoeba"  && part.subtype == "mouths"{
            currentImageViews[part.category]![part.subtype]?.frame = CGRect(x:(displaywidth/2)-20, y:180, width: 70, height: 30)
        }

        else {
            currentImageViews[part.category]![part.subtype]?.frame = CGRect(x:15, y:10, width: displaywidth, height: displayheight)
        }
        
        
        currentParts[part.category]![part.subtype] = part.index
        currentButtons[part.category]![part.subtype] = button
        reorder(view: view)
        return true
        
        
    }
    //Since the base is not a part, it needs a separate method to recolor it.
    func baseRecolor(view: Characterizer) -> Bool{
        for base in self.bases[self.kind]!{
            var image = UIImage(named: "parts/base-"+base)
            
            if image == nil {return false}
            image = image!.imageWithColor(color1: currentColors[self.kind]!["base"]!, mode: .multiply)
            
            
            //replace old image with new one
            currentImageViews[self.kind]!["base-"+base]?.image = image
            if base == "amoeba" {
                currentImageViews[self.kind]!["base-"+base]!.frame = CGRect(x:15, y:100, width: displaywidth, height: 150)
            }
            else {
            currentImageViews[self.kind]!["base-"+base]?.frame = CGRect(x:15, y:10, width: displaywidth, height: displayheight)
            }
        }
        
        reorder(view: view)
        return true
        
        
    }
    
    //initialize all of the parts to default values
    // There are an indeterminate amount of files in each folder
    // with numbers at the end which could be anything between 1 and 59.
    // We try each one, and take the first one we find.
    func setup(view:Characterizer){
        for typ in self.types[self.kind]!{
            for subtyp in self.parts[typ]!{
                for i in 1 ..< 60 {
                    if self.partSelected(part: PartInfo(category: typ, subtype: subtyp, index: i), button: UIButton(), view: view){
                        view.view.addSubview(currentImageViews[typ]![subtyp]!)
                        break //stop at the first image that exists
                    }
                }
            }
        }
        //load the kind's base image
        for base in self.bases[self.kind]!{
            currentColors[self.kind]!["base"] = UIColor.white
            
            var image = UIImage(named: "parts/base-"+base)
            
            image = image!.imageWithColor(color1: currentColors[self.kind]!["base"]!, mode: .multiply)
            
            currentImageViews[self.kind]!["base-"+base] = UIImageView(image: image)
            view.view.addSubview(currentImageViews[self.kind]!["base-"+base]!)
            if base == "amoeba" {
                currentImageViews[self.kind]!["base-"+base]!.frame = CGRect(x:15, y:100, width: displaywidth, height: 150)
            }
            else {
            currentImageViews[self.kind]!["base-"+base]!.frame = CGRect(x:15, y:10, width: displaywidth, height: displayheight)
            }
        }
        setUp = true
        reorder(view: view)
    }
    
    //draw all imageviews again in order
    func reorder(view:Characterizer){
        let avatar_stand_image = UIImage(named: "icons/Avatar_Stand.png")
        let avatar_image = UIImageView(frame: CGRect(x:10, y:displayheight-70, width: displaywidth, height: 80))
        avatar_image.image = avatar_stand_image
        view.view.addSubview(avatar_image)

        var i = 0
        for typ in self.types[self.kind]!{
            for subtyp in self.parts[typ]!{
                if setUp && i==baseIndex[self.kind]{
                    for base in self.bases[self.kind]!{
                        view.view.bringSubview(toFront: currentImageViews[self.kind]!["base-"+base]!)
                    }
                }
                i += 1
                
                
                view.view.bringSubview(toFront: currentImageViews[typ]![subtyp]!)
            }
        }
        

    }
    
    //Composite all layers together in preparation to save the combined image
    func getImage() -> UIImage{
        var imgs = [UIImage]()
        var img = UIImage()
        var i = 0
        for typ in self.types[self.kind]!{
            for subtyp in self.parts[typ]!{
                if setUp && i==baseIndex[self.kind]{
                    for base in self.bases[self.kind]!{
                        imgs.append(currentImageViews[self.kind]!["base-"+base]!.image!)
                    }
                }
                i += 1
                if i>1 {
                    imgs.append(currentImageViews[typ]![subtyp]!.image!)
                }
                else {
                    img = currentImageViews[typ]![subtyp]!.image!
                }
            }
        }
        return img.composite(images: imgs)

    }
    
    //When you are done with the imp, this should remove all associated information
    func destroy(){
        //remove each imageview individually
        for typ in types[kind]!{
            for subtyp in parts[typ]!{
                currentImageViews[typ]![subtyp]!.removeFromSuperview()
                currentImageViews[typ]![subtyp] = nil
            }
        }
        //also remove each base
        for base in self.bases[self.kind]!{
            currentImageViews[self.kind]!["base-"+base]!.removeFromSuperview()
            currentImageViews[self.kind]!["base-"+base] = nil
        }
        currentImageViews.removeAll()
    }
    
    //Find out which page (and index within that page) a given part scroller should be on
    func findInPage(goal: String) -> (Int, Int) {
        for (i, page) in pages[kind]!.enumerated(){
            for (j, subtype) in page.contents.enumerated(){
                if subtype == goal{
                    return (i, j)
                }
            }
        }
        return (-1, -1)
    }
    
}
