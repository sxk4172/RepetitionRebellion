//
//  Users.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation

class Users {
    
    private var _username: String!
    private var _userKey: String!
    private var _journalname: String!
    private var _journalcontent: String!
    private var _journaldate: String!
    private var _audioMessage: NSString?

    
    var journaldate: String?{
        return _journaldate
    }
    
    var journalcontent: String?{
        return _journalcontent
    }
    
    
    var username: String? {
        return _username
    }
    
    var journalname: String? {
        return _journalname
    }
    
    var audioMessage: NSString? {
        return _audioMessage
    }
    
    //to receive from firebase
    init (userKey: String, dictionary: Dictionary<String, AnyObject>){
        self._userKey = userKey
        
        if let uName = dictionary["username"] as? String {
            self._username = uName
        }
        
        if let jName = dictionary["journalName"] as? String {
            self._journalname = jName
        }
        
        if let jContent = dictionary["journalContent"] as? String {
            self._journalcontent = jContent
        }
        
        if let jDate = dictionary["journalDate"] as? String {
            self._journaldate = jDate
        }
        
        if let aMessage = dictionary["audioMessage"] as? NSString {
            self._audioMessage = aMessage
        }
    }
    
}