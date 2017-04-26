//
//  fullJournalView.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/5/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import AVFoundation

class fullJournalView: UIViewController {

    var audioPlayer = AVAudioPlayer()
    var audioString: NSString!
    var journaln: Users!
    var journalc: Users!
    
    @IBOutlet weak var journalNameText: UILabel!
    @IBOutlet weak var journalContentText: UITextView!
    @IBOutlet weak var imageClick: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("jou : \(journalRowIndex)")
        let journaln = journalName.reversed()[journalRowIndex]
        let journalc = journalContent.reversed()[journalRowIndex]
        
        configureCell(users: journaln)
        
        configureCell(users: journalc)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    func configureCell(users: Users){
        self.journaln = users
        self.journalc = users
        
        if let journalN = users.journalname, users.journalname != "" {
            self.journalNameText.text = journalN
        }
        
        if let audioM = users.audioMessage, users.audioMessage != nil {
            audioString = audioM
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(fullJournalView.imageTapped))
            imageClick.isUserInteractionEnabled = true
            imageClick.addGestureRecognizer(tapGestureRecognizer)
        }
        
        if let journalC = users.journalcontent, users.journalcontent != "" {
            self.journalContentText.text = journalC
        }
        
    }
    
    func imageTapped() {
        let audioData = NSData(base64Encoded: audioString as String, options: [])
        print("Inside image Tapped full")
        do {
            try  audioPlayer = AVAudioPlayer(data: audioData! as Data)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch {
        }
    }

  
}
