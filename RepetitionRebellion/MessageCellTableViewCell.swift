//
//  MessageCellTableViewCell.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/14/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//



import UIKit
import AVFoundation

class MessageCellTableViewCell: UITableViewCell {
    var audioPlayer = AVAudioPlayer()
    var audioString: String!
    @IBOutlet weak var imageClick: UIImageView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    var message: Message!
    var usern: Users!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        messageImage.layer.cornerRadius = messageImage.frame.size.width / 2
        messageImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func configure(usern: Users){
        self.usern = usern
        
        if let Nuser = usern.username, usern.username != "" {
            self.username.text = "Message From \(Nuser)"
        }
        
    }
    
    func configureCell(message: Message){
        self.message = message
        
        if let textM = message.textMessage, message.textMessage != "" {
            
            if textM.range(of:"Audio Message Click Image") != nil {
                self.messageText.text = textM
            }
            else {
                let DES = CryptoJS.AES()
                let decrypted = DES.decrypt(textM, password: "password123")
                
                self.messageText.text = decrypted
            }
        }
        
        if let audioM = message.audioMessage, message.audioMessage != nil {
            audioString = audioM
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(MessageCellTableViewCell.imageTapped))
            imageClick.isUserInteractionEnabled = true
            imageClick.addGestureRecognizer(tapGestureRecognizer)
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
    
}
