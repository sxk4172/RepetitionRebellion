//
//  MissionsTableViewController.swift
//  Repetition Rebellion
//
//  Created by Sean Maraia on 6/1/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase
import CoreData

///A Protocol for View Controllers which will display a modal view controller that modifies it's parents data.
/// - SeeAlso modalVCChild
protocol  modalVCParent : class{
    ///called by a child VC that conforms to the modalVCChild protocol as the completion handler to dismissViewControllerAnimated
    
    func modalDidUnwind(data: [String: AnyObject]?)
}

///A Protocol for ViewControlllers which hae a parent conforming to modalVCParent, and call their parent's modalDidUnwind function when they are dismissed
/// - SeeAlso modalVCParent
protocol modalVCChild {
    ///this VCs parent VC, which conforms to the modalVCParent protocol
    var modalParent: modalVCParent? {get set}
    
    func unwindModal()
}

extension modalVCChild where Self: UIViewController {
    func unwindModal() {
        (self as UIViewController).dismiss(animated: true, completion: {self.modalParent!.modalDidUnwind(data: nil)})
    }
}

class MissionsTableViewController: UITableViewController, modalVCParent {
    var imp_image: UIImage!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        print("add button tapped")
        performSegue(withIdentifier: "addMission", sender: self)
        
    }
    @IBOutlet weak var topVIEW: UIView!
    @IBAction func backPressed(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        self.present(viewController, animated: false, completion: nil)
    }
   // @IBOutlet var missionTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mission view did load")
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let imps = appDel.loadEntityFromName(entityName: "Imp")
        if let imp = imps.last {
            let imp_data = ((imp as Any) as AnyObject).value(forKey: "image")
                imp_image = UIImage(data: imp_data as! Data)!
                print(imp_image)
        }
//            Missions.sharedInstance.pullMissionDB() {_ in
//            if Missions.sharedInstance.count <= 1 {
//                Missions.sharedInstance.initialize()
//                print("==0")
//
//            }
            self.tableView.reloadData()
   //     }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("will appear")
        self.tableView.reloadData()
        let backgroundImage = UIImage(named: "Space.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.topVIEW.backgroundColor = UIColor(patternImage: backgroundImage!)
//        Missions.sharedInstance.pullMissionDB() {_ in/Users/sanikakulkarni/Desktop/migrate to 8.3 part 3/RepetitionRebellion/RepetitionRebellion/AppDelegate.swift
//            if Missions.sharedInstance.count <= 1 {
//                Missions.sharedInstance.initialize()
//                print("==0")
//                
//            }
            self.tableView.reloadData()
     //   }
    }
    
    
    func addTapped() {
        performSegue(withIdentifier: "addMission", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Missions.sharedInstance.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        mission =  Missions.sharedInstance[indexPath.row]

        performSegue(withIdentifier: "showDetail", sender: self)

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath as IndexPath) as! MissionTableViewCell
                //get a the mission for the index of the cell, and set the cell's nameLabel to the name of the mission
            let mission = Missions.sharedInstance[indexPath.row]
        
//            if let image = imp_image {
//                cell.impImageView.image = image
//                cell.impImageView.contentMode = .scaleAspectFit
//                cell.impImageView.backgroundColor = UIColor.clear
//            }
        
        let imageData = UserDefaults.standard.object(forKey: "loadImage")
        if imageData != nil {
            cell.impImageView.image = UIImage(data: (imageData as! Data))
            cell.impImageView.contentMode = .scaleAspectFit
            cell.impImageView.backgroundColor = UIColor.clear
        }
        else {
            cell.impImageView.image = UIImage(named: "GooBody.png")
            cell.impImageView.contentMode = .scaleAspectFit
            cell.impImageView.backgroundColor = UIColor.clear
        }
            // use your image here...
        
            cell.missionNameLabel.text = mission.name
                
                // Configure the cell...
            cell.backgroundColor = .clear
            return cell
    }
    
    
    // MARK: - Navigation
    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        //if selecting a row
//        if segue.identifier == "showDetail" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                //set the mission variable of the Mission Detail View Controller to the mission at the selected index
//                (segue.destination as! MissionDetailViewController).mission = Missions.sharedInstance[indexPath.row]
//            }
//        } else if segue.identifier == "addMission" { // if the segue is the one to add a new Mission, then the destinationViewController needs a modalParent
//            (segue.destination as! AddMissionViewController).modalParent = self
//        }
//        
//        
//        
//    }
    
    func modalDidUnwind(data: [String: AnyObject]? = nil) {
        self.tableView.reloadData()
    }
    
    
}
