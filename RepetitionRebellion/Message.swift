//
//  Message.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import Foundation
class Message {
    
    private var _textMessage: String?
    private var _audioMessage: String?
    private var _messageKey: String!
    
    var audioMessage: String? {
        return _audioMessage
    }
    
    var textMessage: String? {
        return _textMessage
    }
    
    //to send to firebase
    init(textMessage: String?){
        self._textMessage = textMessage
    }
    
    init(audioMessage: String?){
        self._audioMessage = audioMessage
    }
    
    //to receive from firebase
    init (messageKey: String, dictionary: Dictionary<String, AnyObject>){
        self._messageKey = messageKey
        
        if let tMessage = dictionary["textMessage"] as? String {
            self._textMessage = tMessage
        }
        
        if let aMessage = dictionary["audioMessage"] as? String {
            self._audioMessage = aMessage
        }
        
    }
    
    
    
}