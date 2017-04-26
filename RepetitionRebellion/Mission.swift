//
//  Mission.swift
//  Repetition Rebellion
//
//  Created by Sean Maraia on 6/1/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
import Firebase

/// A singleton that contains an array of Mission structs.
///
/// - SeeAlso: `Mission`
class Missions {
    static let sharedInstance = Missions()
    
    var data: [Mission] = []
    private init () {}
    
    /// Allows for bracket notation to directly access the data array.
    subscript (index: Int) -> Mission {
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
        print("initialize")
        data = [Mission(name: "Mission One", points: Int(arc4random() % 100)), Mission(name: "Mission Two", points: Int(arc4random() % 100)), Mission(name: "Mission Three", points: Int(arc4random() % 100))]
    }
    
    /// Pushes the data array to the Firebase Realtime Database entry for the user's Missions.
    func updateMissionsDB() {
        print("set misions")
        //set missions on Firebase to this value
        let _REF_Users_currentUser_missions = FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/missions")
        for mission in data {
            print("inside loop missions")
            var toolsString = ""
            for tool in mission.tools {
                print("inside loop missions1")
                toolsString += "\(tool)"
            }
            let key = mission.name+"\(mission.time_assigned)" + toolsString
            let cleanKey = key.addingPercentEncoding( withAllowedCharacters:(NSCharacterSet.alphanumerics))
            print(mission.toDict())
            _REF_Users_currentUser_missions.child(byAppendingPath: cleanKey!).setValue(mission.toDict())
            print("inside loop missions2")

        }
        
        
    }
    

    /// Sets the data array to match the data for the current user's Missions array on Firebase.
    /// - parameter completion: A block of code guaranteed to execute once the data array has been updated.
    func pullMissionDB(completion: ((_ success: Bool)->Void)? = nil) {
        let missionsReference = FIRDatabase.database().reference(fromURL:  "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/missions")
        self.data.removeAll()
            missionsReference.observe(.value, with: {snapshot in
                if let allMissions = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    var countMissions = 0
                    for missionSnap in allMissions {
                        if let missionDict = missionSnap.value as? Dictionary<String, AnyObject> {
                            let key = missionSnap.key
                            let mission = Mission(missionKey: key, dictionary:  missionDict)
                            if countMissions == allMissions.count {
                                print("done")
                            }
                            else {
                                self.data.append(mission)

                            }
                            countMissions = countMissions + 1

                        }
                    }
                }
                
                completion?(true)
                })
        }
    
}

enum MissionType: String {
    case TimedMission = "Timed Mission"
    case TrainingMission = "Training Mission"
    case ActiveMission = "Active Mission"
    
    static let types: [MissionType] = [.TimedMission, .TrainingMission, .ActiveMission]
}

/// A struct containing the data of a Mission, matching the schema of the Firebase Databse
struct Mission: Equatable {
    let name:String
    let kind:String
    let details:String
    let tools:[Int]
    let imp:Int
    let time_assigned: TimeInterval
    let end_time: TimeInterval
    let points:Int
    let goal_points:Int
    
    
    
    var _missionKey: String!
    
    init(name: String = "Mission Name", kind : String =  "Timed Mission", details: String = "This mission's details are described in this box, where the user can get a detailed reminder of exactly what their practitioner has requested they do for this mission.", tools: [Int] = [1, 2, 0], imp: Int = 0, time: TimeInterval = NSDate.timeIntervalSinceReferenceDate, ending: TimeInterval = NSDate.timeIntervalSinceReferenceDate, points: Int = 0, goal : Int = 100){
        self.name = name
        self.kind = kind
        self.details = details
        self.tools = tools
        self.imp = imp
        time_assigned = time
        end_time = ending
        self.points = points
        goal_points = goal
    }
    
    init(missionKey: String, dictionary: Dictionary<String, AnyObject>){
        self._missionKey = missionKey
        
        if let tname = dictionary["name"] as? String {
            name = tname
        } else { name = ""}
        
        if let tkind = dictionary["kind"] as? String {
            kind = tkind
        } else { kind = ""}
        
        if let tdetails = dictionary["details"] as? String {
            details = tdetails
        } else { details = ""}
        
        
        if let ttools = dictionary["tools"] as? [Int] {
            tools = ttools
        }  else { tools = []}
        
        if let timp = dictionary["imp"] as? Int {
            imp = timp
        } else { imp = 0}
        
        if let ttime = dictionary["time"] as? TimeInterval {
            time_assigned = ttime
        } else { time_assigned = NSDate.timeIntervalSinceReferenceDate}
        
        if let tend = dictionary["ending"] as? TimeInterval {
            end_time = tend
        } else {end_time = NSDate.timeIntervalSinceReferenceDate}
        
        if let tpoints = dictionary["points"] as? Int {
            points = tpoints
        } else { points = 0}
        
        if let tgoal = dictionary["goal"] as? Int {
            goal_points = tgoal
        } else { goal_points = 100}
        
    }
    

    func toDict() -> Dictionary<String, AnyObject> {
        var dict = Dictionary<String, AnyObject>()
        
        dict["name"] = name as AnyObject?
        dict["kind"] = kind as AnyObject?
        dict["details"] = details as AnyObject?
        dict["imp"] = imp as AnyObject?
        dict["time"] = time_assigned as AnyObject?
        dict["ending"] = end_time as AnyObject?
        dict["points"] = points as AnyObject?
        dict["tools"] = tools as AnyObject?
        dict["goal"] = goal_points as AnyObject?
        return dict
    }

}

func ==(lhs: Mission, rhs: Mission) -> Bool {
    return true
}
