//
//  HelperData.swift
//  Repetition Rebellion
//
//  Created by Stephen Jacobs on 3/10/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
import UIKit




//the colors for the part button backgrounds
let option_bg_normal = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1)
let option_bg_selected = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)

//screen size of iphone 6 (380x670)
let screenSize: CGRect = UIScreen.main.bounds
let screen_height = screenSize.height
let screen_width = screenSize.width

//The size to draw the characterizerimages at
// 5/3 ratio (210x350)
let displayheight = screen_height/2
let displaywidth = (displayheight*3)/5

// The size of the screen compared to the original expected size. 
// Values can be scaled by multiplying with this.
let g_ratio = screen_height/670

//the size of save/load/etc buttons in characterizer
let buttonsize:CGFloat = 64 * g_ratio


//Adds methods to the UIImage class
extension UIImage {
    
    //Draw an image in a different color - code modified from:
    //http://stackoverflow.com/questions/19274789/how-can-i-change-image-tintcolor-in-ios-and-watchkit
    func imageWithColor(color1: UIColor, mode: CGBlendMode) -> UIImage {
        //create a new graphics context, and set it as the current one
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        //make a rectangle the size of the image
        //let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        //the next time we use a fill operation, it will use this color
        color1.setFill()
        //draw the original picture in the new context, to be modified later
        self.draw(in: rect, blendMode: .normal, alpha: 1)
        
        //get the current context that we just created
        let context = UIGraphicsGetCurrentContext()! as CGContext
        //set the origin point to the upper left
        context.translateBy(x: 0, y: self.size.height)
        //flip all future actions vertically
        context.scaleBy(x: 1.0, y: -1.0)
        //make the next fill operation use the specified blend mode
        context.setBlendMode(mode)
        
        //restrict fill to the area of the rectangle and the alpha of the image
        context.clip(to: rect, mask: self.cgImage!)
        //fill using current color and blend mode
        context.fill(rect)
        
        //convert back to UIImage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        //close the context, ending image manipulation
        
        return newImage
    }
    
    // Return composite image of images overlayed on image1
    func composite(images: [UIImage]) -> UIImage {
       // let bounds1 = CGRectMake(0, 0, self.size.width, self.size.height)
        let bounds1 = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        //create a new graphics context, and set it as the current one
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        //get the current context that we just created
        //let ctx = UIGraphicsGetCurrentContext()! as CGContextRef
        
        //draw the base image
        self.draw(in: bounds1, blendMode: .normal, alpha: 1)
        //CGContextDrawImage(ctx, bounds1, self.CGImage)
        //CGContextSetBlendMode(ctx, .Normal) // one image over the other
        for image in images {
            //let bounds2 = CGRectMake(0, 0, image.size.width, image.size.height)
            let bounds2 = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            image.draw(in: bounds2, blendMode: .normal, alpha: 1)
            //CGContextDrawImage(ctx, bounds2, image.CGImage)
        }
        //convert back to UIImage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        //close the context, ending image manipulation
        
        return newImage
    }
}
