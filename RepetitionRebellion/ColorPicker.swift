//
//  ColorPicker.swift
//  Repetition Rebellion
//
//  Created by Stephen Jacobs on 7/5/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
import UIKit


class ColorPicker: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //The category and subtype of the part this picker pertains to
    var category:String = ""
    var subtype:String = ""
    //We keep the characterizer so we can call back when a color is picked. May be a cyclical reference, consider 'weak'
    var characterizer:Characterizer? = nil
    
    //Everywhere outside of the picker frame counts as an exit button
    let bg = UIButton(type:UIButtonType.system)
    
    let size:CGFloat = 42*g_ratio
    
    let collectionView = UICollectionView(
        frame:CGRect(x: 10,
            y: Int(screen_height - 50),
            width: Int(screen_width - 20),
            height: 45),
            collectionViewLayout: UICollectionViewFlowLayout())
    
    
    //Gets the number of items in the color picker's collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Height is : \(screen_height)")
        print("width is : \(screen_width)")
        return colors.count
    }
    
    //Creates each of the color buttons
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        let button   = UIButton(type:UIButtonType.system)
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        cell.backgroundColor = colors[indexPath.item]
        button.tintColor = colors[indexPath.item]
        button.tag = indexPath.item

        button.addTarget(self, action: #selector(ColorPicker.colorPicked(sender:)), for:.touchUpInside)
        cell.contentView.addSubview(button)
        
        print ( "Index : \(indexPath)  \(cell)")
        
        return cell
    }
    
//    //Creates the footer 'close' button
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        switch kind {
//            
//        case UICollectionElementKindSectionFooter:
//            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath)
//            
//            
//            let button   = UIButton(type:UIButtonType.System)
//            button.frame = footer.bounds
//            
//            //button.backgroundColor = UIColor.grayColor();
//            button.setTitle("close", forState: .Normal)
//            button.titleLabel!.font = UIFont.systemFontOfSize(16*g_ratio)
//            button.addTarget(self, action: #selector(ColorPicker.colorPickerClose(_:)), forControlEvents:.TouchUpInside)
//            footer.addSubview(button)
//            
//            print ("Footer: ", footer)
//            return footer
//            
//        default:
//            
//            assert(false, "Unexpected element kind")
//        }
//        return UICollectionReusableView()
//    }
    
    //Sets up the collectionview full of colors with a new category and subtype
    func colorPicker(category: String, subtype: String, characterizer:Characterizer){
        self.category = category
        self.subtype = subtype
        self.characterizer = characterizer

        //let row_width = 8
        
        bg.frame = CGRect(x: 0, y: 0, width: CGFloat(screen_width), height: CGFloat(screen_height))
        bg.addTarget(self, action: #selector(ColorPicker.colorPickerClose(sender:)), for:.touchUpInside)
        characterizer.view.addSubview(bg)
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: size, height: size)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).footerReferenceSize = CGSize(width: screen_height-80, height: size);

        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "Footer")
        characterizer.view.addSubview(collectionView)

        
        
        
        
    }
    //When a color is picked, we send it back to the characterizer
    func colorPicked(sender:UIButton) {
        characterizer?.colorPicked(info: PartInfo(category:category, subtype: subtype, index: sender.tag))
    }
    
    //When the picker is no longer needed, we hide it and its fullscreen close button
    func colorPickerClose(sender:UIButton) {
        bg.removeFromSuperview()
        collectionView.removeFromSuperview()
        //characterizer.colorPickerClose()
    }

    
}


//the color options for the characterizer color picker
let colors = [
    //pure
    UIColor(red: 1, green: 0, blue: 0, alpha: 1),//red
    UIColor(red: 1, green: 0.5, blue: 0, alpha: 1),//orange
    UIColor(red: 1, green: 1, blue: 0, alpha: 1),//yellow
    UIColor(red: 0, green: 1, blue: 0, alpha: 1),//green
    UIColor(red: 0, green: 1, blue: 1, alpha: 1),//cyan
    UIColor(red: 0, green: 0, blue: 1, alpha: 1),//blue
    UIColor(red: 0.5, green: 0, blue: 1, alpha: 1),//purple
    UIColor(red: 1, green: 0, blue: 1, alpha: 1),//magenta
    
]
