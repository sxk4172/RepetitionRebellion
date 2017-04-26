//
//  UtilityBeltViewController.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 3/30/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//save images in array from database


//to keep track of image
var temp = 0
var i = 0
var tempImage = 1


//For storing in data
let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate

let context:NSManagedObjectContext = appDel.persistentContainer.viewContext


var newEntry: NSManagedObject?

class UtilityBeltViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var selectedIndex: Int = -1
    
    @IBOutlet weak var carousel: iCarousel!
    
//    func setupCarousel() {
//        
//        
//        //Adds constraints to the carousel view to pin it to the edges of the view
//        let topConstraint = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0.0)
//        let botConstraint = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0.0)
//        let leadConstraint = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0.0)
//        let trailConstraint = NSLayoutConstraint(item: carousel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0.0)
//        
//        view.addConstraints([topConstraint, botConstraint, leadConstraint, trailConstraint])
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.delegate = self
        carousel.dataSource = self
        print(Toolbelt.sharedInstance.count)
    }
    @IBAction func backButtonPresssed(_ sender: Any) {
        
        print("back pressed")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool)   {
        super.viewWillAppear(true)
        carousel.type = .cylinder
        carousel.reloadData()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = addButton
        Toolbelt.sharedInstance.pullFromDB() { _ in
            if Toolbelt.sharedInstance.count == 0 {
                Toolbelt.sharedInstance.initialize()
            }
            self.carousel.reloadData()
        }

        
    }
    
    
    func addTapped() {
        performSegue(withIdentifier: "addTool", sender: self)
        print(Toolbelt.sharedInstance.count)
        print(Toolbelt.sharedInstance.data)
    }
    
    
     func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if carousel != nil {
            coordinator.animate(alongsideTransition: nil, completion: {void in
                self.carousel.reloadData()
                
            })
            
        }
        carousel.reloadData()
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return Toolbelt.sharedInstance.count * 2
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return 0.5 * self.view.frame.width
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //var itemView: UIVisualEffectView
        var itemView : UIImageView
        if (view == nil)
        {
            
            itemView = UIImageView()
            itemView.image = UIImage(named: "Belt")
            itemView.contentMode = .scaleAspectFit
            itemView.frame = CGRect(x: -1, y: 0, width: carousel.itemWidth + 2, height: carousel.frame.height * 0.75)
            
            
            if(index % 2 == 0 && numberOfItems(in: carousel) > 0) {
                
                let trueIndex = index/2
                let currentTool = Toolbelt.sharedInstance[trueIndex]
                
                let imageView = UIImageView()
                imageView.image = currentTool.featuredImage
                imageView.sizeToFit()
                
                
                imageView.frame = CGRect(x: (itemView.frame.width - itemView.frame.width * 0.9) * 0.5, y: (itemView.frame.height - (itemView.frame.width * 0.9)) * 0.5, width: itemView.frame.width * 0.9, height: itemView.frame.width * 0.9)
                
                itemView.addSubview(imageView)
                
                itemView.layer.edgeAntialiasingMask = [.layerBottomEdge, .layerTopEdge]
                itemView.layer.allowsEdgeAntialiasing = true
                
                imageView.layer.allowsEdgeAntialiasing = true
                imageView.layer.edgeAntialiasingMask = [.layerBottomEdge, .layerTopEdge]
                
                let label = UILabel()
                label.text = currentTool.title
                label.textColor = UIColor.white
                label.sizeToFit()
                label.textAlignment = .center
                label.frame =  CGRect(x: 0, y: (3 * itemView.frame.height) / 5.0, width: itemView.frame.width, height: label.frame.height)
                label.center = CGPoint(x: imageView.center.x, y: imageView.center.y - (0.5 * (imageView.frame.height + label.frame.height)))
                //itemView.contentView.addSubview(label)
                itemView.addSubview(label)
                
                let description = UILabel()
                description.text = currentTool.description
                description.textColor = UIColor.white
                description.lineBreakMode = .byWordWrapping
                description.numberOfLines = 0
                description.backgroundColor = .clear
                description.sizeToFit()
                description.textAlignment = .center
                description.frame =  CGRect(x: 0, y: (4 * itemView.frame.height) / 5.0, width: itemView.frame.width, height: description.frame.height * 3)
                description.center = CGPoint(x: imageView.center.x, y: imageView.center.y + (imageView.frame.height * 0.5) + (description.frame.height * 0.5))
                
                //itemView.contentView.addSubview(description)
                itemView.addSubview(description)
            }
            
        }
        else
        {
            //itemView = view as! UIVisualEffectView
            itemView = view as! UIImageView
            if index % 2 == 0 {
                for subview in (itemView.subviews)
                {
                    let currentTool = Toolbelt.sharedInstance[index/2]
                    if subview is UIImageView {
                        
                        let imageView = subview as! UIImageView
                        imageView.image = currentTool.featuredImage
                    } else if subview is UILabel {
                        let labelView = subview as! UILabel
                        if labelView.lineBreakMode == .byWordWrapping {
                            labelView.text = currentTool.description
                        }
                        else {
                            labelView.text = currentTool.title
                        }
                    }
                }
            }
        }
        
        return itemView
        
    }
    
    func modalDidUnwind(data: [String: AnyObject]? = nil) {
        print(Toolbelt.sharedInstance.count)
        print(Toolbelt.sharedInstance.data)
//        carousel.removeFromSuperview()
    }
    
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if carousel.currentItemIndex % 2 == 0 && fabs(carousel.scrollOffset - CGFloat(carousel.currentItemIndex)) <= 0.05 {
            carousel.autoscroll = 0
        }
    }
    
    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
        if carousel.currentItemIndex % 2 == 1 {
            let scrollDir = -((carousel.scrollOffset - floor(carousel.scrollOffset)) - 0.5)
            
            carousel.autoscroll = fabs(scrollDir) / scrollDir
        }
        
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        if carousel.currentItemIndex % 2 == 1 {
            let scrollDir = -((carousel.scrollOffset - floor(carousel.scrollOffset)) - 0.5)
            carousel.autoscroll = fabs(scrollDir) / scrollDir
        }
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if index % 2  == 0 {
            selectedIndex = index
            toolIndex = selectedIndex / 2
            performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  carousel.removeFromSuperview()
        carousel.dataSource = nil
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        
    }
    
    
}
