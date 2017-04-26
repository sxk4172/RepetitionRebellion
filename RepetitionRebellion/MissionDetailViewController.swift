//
//  MissionDetailViewController.swift
//  Repetition Rebellion
//
//  Created by Sean Maraia on 6/1/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit

var mission: Mission!

class MissionDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var missionNameLabel: UILabel!
    @IBOutlet weak var missionDescriptionTextView: UITextView!
    @IBOutlet weak var missionToolsCollectionView: UICollectionView!
    @IBOutlet weak var DescriptionContainingView: UIView!
    @IBOutlet weak var collectionViewShadowView: TransparentView!
    
    
    
    @IBOutlet weak var ProgressView: UIView!
    @IBOutlet weak var ProgressBackground: UIView!
    @IBOutlet weak var ProgressWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //In case the VC is somehow instantiated WITHOUT a mission (should be done in the segue) one is created
        if mission == nil {
            mission = Mission(name: "Error; no mission set", points: Int(arc4random() % 100))
        }
        
        //ensures that the assigned and due dates of the mission are readable
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY"
        missionToolsCollectionView.dataSource = self
        missionToolsCollectionView.delegate = self
        //sets the labels
        missionNameLabel.text = "\(mission.points) / \(mission.goal_points)"
        let missionTiming = "Assigned: \(formatter.string(from: NSDate(timeIntervalSinceReferenceDate: mission.time_assigned) as Date)) \nEnds: \(formatter.string(from: NSDate(timeIntervalSinceReferenceDate: mission.end_time) as Date))\n"
        missionDescriptionTextView.text = missionTiming + mission.details
        missionDescriptionTextView.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue :51/255.0, alpha: 1.0)
        
        navigationItem.title = mission.name
        
        //Allow backgrounds to have grey borders so that they can have innershadows
        ProgressBackground.layer.borderColor = UIColor(white: 230.0/255.0, alpha: 1.0).cgColor
        DescriptionContainingView.layer.borderColor = UIColor(white: 230.0/255.0, alpha: 1.0).cgColor
        missionToolsCollectionView.layer.borderColor = UIColor(white: 230.0/255.0, alpha: 1.0).cgColor
        ProgressView.backgroundColor = UIColor.red
        
        DescriptionContainingView.addInnerShadow()
        missionToolsCollectionView.backgroundView = UIView(frame: missionToolsCollectionView.frame)
        
        missionToolsCollectionView.backgroundView?.backgroundColor = UIColor.white
        collectionViewShadowView.addInnerShadow()
        
    }

        
        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            coordinator.animate(alongsideTransition: nil, completion: {
                _ in
                
                self.adjustProgressRadius()
                self.missionToolsCollectionView.reloadData()

            })
            
        
    }
    
    
    ///An animated transition from the progress bar's current cornerRadius to the correct value to have circular endcaps
    func adjustProgressRadius(){
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = ProgressView.layer.cornerRadius
        animation.toValue = ProgressView.frame.size.height/2
        animation.duration = 0.25
        ProgressView.layer.add(animation, forKey: "cornerRadius")
        ProgressView.layer.cornerRadius = ProgressView.frame.size.height/2
        ProgressBackground.layer.add(animation, forKey: "cornerRadius")
        ProgressBackground.layer.cornerRadius = ProgressView.frame.size.height/2
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustProgressRadius()
        //The progress bar is just two normal UIViews. one for the background and one for the progress bar.
        //The progress bar view has constraints on it's width and is pinned to the left side of the background View
        
        let progress = Float(mission.points) / Float(mission.goal_points)
        
        let newConstraint = NSLayoutConstraint(item: ProgressView, attribute: .width, relatedBy: .equal, toItem: ProgressBackground, attribute: .width, multiplier: CGFloat(progress), constant: 0)
        
        //The View then animates it's width to be a fraction of the background view's width, equal to the progress Float
        //The color is also animated from red to green based on the progress
        UIView.animate(withDuration: Double(progress), delay: 0.0, options: .curveEaseOut , animations: {
            if(self.ProgressWidthConstraint != nil) {
                self.ProgressWidthConstraint.isActive = false
                newConstraint.isActive = true
                self.ProgressView.backgroundColor = UIColor(red: 1 - CGFloat(progress), green: CGFloat(progress), blue: CGFloat(progress) * 0.5, alpha: 1.0)
                self.view.layoutIfNeeded()
            }
            
            }, completion: nil)
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("view will appar")
        
        ProgressView.layer.cornerRadius = ProgressView.frame.size.height/2
        
        ProgressBackground.layer.cornerRadius = ProgressView.frame.size.height/2
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(mission.tools.count)
        return mission.tools.count
    }
    
    
    
    @objc func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //size the cell to fit
        cell.sizeToFit()
        
        //makes sure the flowLayout exists
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        //if the cell is the same size as the flowLayout wants, then return
        if cell.frame.size == flowLayout.itemSize {
            return
        }
        
        //get an itemHeight that fits the screen size, and set it as the flowLayout's itemsize
        let itemHeight = cell.frame.size.height - collectionView.contentInset.bottom - collectionView.contentInset.top - flowLayout.sectionInset.bottom - flowLayout.sectionInset.top
        
        flowLayout.itemSize = CGSize(width: itemHeight, height: itemHeight)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "missionTool", for: indexPath as IndexPath) as! MissionToolCollectionViewCell
        //set the index of the tool to be the Int at index indexPath.row in this mission's tools array
        let toolIndex = mission.tools[indexPath.row]
        
        //makes sure that the tool can exist as a sanity check and for safety
        if Toolbelt.sharedInstance.count > toolIndex {
            //sets the utility of the cell to be the tool at toolIndex
            cell.utility = Toolbelt.sharedInstance[toolIndex]
        } else {
            //otherwise just show the first tool if something goes wrong
            cell.utility.featuredImage = UIImage(named: "tool_1.png")
            cell.utility.description = "Helps you fight the imp"
            cell.utility.title = "Gloves"
        }
        
        return cell
        
    }
    
    
    
}
