//
//  DataService.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    
    static let ds = DataService()
    private var _REF_BASE = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com")
    private var _REF_Messages = FIRDatabase.database().reference ( fromURL: "https://repetitionrebellion.firebaseio.com/Messages")
    private var _REF_Users = FIRDatabase.database().reference (fromURL: "https://repetitionrebellion.firebaseio.com/Users")
    
    var REF_BASE : FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_Messages : FIRDatabaseReference {
        return _REF_Messages
    }
    
    var REF_Users : FIRDatabaseReference {
        return _REF_Users
    }
    
    func createFirebaseUser(uid : String, user : Dictionary<String,String>) {
        REF_Users.child(byAppendingPath: uid).setValue(user)
    }

}
