//
//  fullMessageViewController.swift
//  RepetitionRebellion
//
//  Created by Sanika Kulkarni on 4/20/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit
import AVFoundation

var messageFullMessage: Message!
var usernFullmessage: Users!

class fullMessageViewController: UIViewController {

    
    var audioPlayer = AVAudioPlayer()
    var audioString: String!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var communicatorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("fullmessage")
        print(usernFullmessage.username!)
        if let mess = messageFullMessage, let user = usernFullmessage {
            configureCell(message: mess)
            configure(usern: user)
        }
        
        
    }
    
    func configure(usern: Users){
        if let Nuser = usern.username, usern.username != "" {
            print(Nuser)
            self.username.text = "Message From \(Nuser)"
        }
        
    }
    
    func configureCell(message: Message){
        
        if let textM = message.textMessage, message.textMessage != "" {
            if textM.range(of:"Audio Message Click Image") != nil {
                self.textMessage.text = textM
            }
            else {
                let DES = CryptoJS.AES()
                let decrypted = DES.decrypt(textM, password: "password123")
                
                self.textMessage.text = decrypted
            }
            
        }
        
        
        if let audioM = message.audioMessage, message.audioMessage != nil {
            audioString = audioM
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(fullMessageViewController.imageTapped))
            communicatorImage.isUserInteractionEnabled = true
            communicatorImage.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    func imageTapped() {
        let DES = CryptoJS.AES()
        let decrypted = DES.decrypt(audioString as String, password: "password123")
        
        let dataDecoded = NSData(base64Encoded: decrypted, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        do {
            try  audioPlayer = AVAudioPlayer(data: dataDecoded! as Data)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch {
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        
    }


}
