//
//  Extensions.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 4/12/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import Foundation

import UIKit


extension UIImage {
    
    class func imageWithColor(color:UIColor?) -> UIImage! {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext();
        
        if let color = color {
            
            color.setFill()
        }
        else {
            
            UIColor.white.setFill()
        }
        
        context!.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
}

extension UIView {
    
    ///Creates a shadow layer that will make the view look like it is inset within it's parent view
    func addInnerShadow() {
        let innerShadowView = UIImageView(frame: self.bounds)
        innerShadowView.contentMode = .scaleToFill
        innerShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(innerShadowView)
        
        
        innerShadowView.layer.masksToBounds = true
        
        innerShadowView.layer.borderColor = UIColor.lightGray.cgColor
        
        innerShadowView.layer.shadowColor = UIColor.black.cgColor
        innerShadowView.layer.borderWidth = 1.0
        
        innerShadowView.layer.shadowOffset = CGSize.zero
        innerShadowView.layer.shadowOpacity = 1.0
        
        innerShadowView.layer.shadowRadius = 1.5
        innerShadowView.layer.cornerRadius = self.layer.cornerRadius
    }
    
}

///A View that doesn't effect hitTests, allowing for innerShadows to be placed over a collection view, for exapmle, without collection view cells clipping over them
class TransparentView : UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            return nil
        }
        
        return hitView
    }
}
