//
//  JounalTableViewCell.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/4/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import AVFoundation

class JounalTableViewCell: UITableViewCell {
    
    var journaln: Users!
    var audioPlayer = AVAudioPlayer()
    var audioString: NSString!
    
    @IBOutlet weak var imageClick: UIImageView!
    @IBOutlet weak var journalname: UILabel!
    @IBOutlet weak var journaldate: UILabel!
    @IBOutlet weak var journalcontent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(journaln: Users){
        self.journaln = journaln
        
        if let NameJournal = journaln.journalname, journaln.journalname != "" {
            self.journalname.text = NameJournal
        }
        
        if let ContentJournal = journaln.journalcontent, journaln.journalcontent != "" {
            self.journalcontent.text = ContentJournal
        }
        
        if let DateJournal = journaln.journaldate, journaln.journaldate != "" {
            self.journaldate.text = DateJournal
        }
        
        if let audioM = journaln.audioMessage, journaln.audioMessage != nil {
            audioString = audioM
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(JounalTableViewCell.imageTapped))
            imageClick.isUserInteractionEnabled = true
            imageClick.addGestureRecognizer(tapGestureRecognizer)
        }
        
    }
    
    func imageTapped() {
        let audioData = NSData(base64Encoded: audioString as String, options: [])
        do {
            try  audioPlayer = AVAudioPlayer(data: audioData! as Data)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch {
        }
    }
    
    
    
}
