//
//  AudioJournal.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 5/5/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class AudioJournal: UIViewController, AVAudioRecorderDelegate , UITextFieldDelegate {
    
    @IBOutlet weak var journalName: UITextField!
    
    var audioFilename: String!
    var temp = true
    var audioPlayer = AVAudioPlayer()
    var audioURL: NSURL!
    var audioData: NSData!
    var audioString: NSString!
    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalName.delegate = self
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                DispatchQueue.main.async() {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    @IBAction func playButton(_ sender: Any) {
        if let audio = audioURL {
            audioData = NSData(contentsOf: audio as URL)
            audioString = audioData!.base64EncodedString(options: []) as NSString!
            do {
                try  audioPlayer = AVAudioPlayer(data: audioData! as Data)
                audioPlayer.volume = 1.0
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
            }
            catch {
            }
        }

    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func startRecording() {
        audioFilename = getDocumentsDirectory().appending("/recording.m4a")
        audioURL = NSURL(fileURLWithPath: audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL as URL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            
        } else {
            recordButton.setTitle("Try Again! Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func loadRecordingUI() {
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel!.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        recordButton.addTarget(self, action: #selector(AudioJournal.recordTapped), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func showAlert (title: String, msg: String) {
        print("inside show alert")
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        if FileManager.default.fileExists(atPath: audioFilename) {
            do {
                try FileManager.default.removeItem(atPath: audioFilename)
                print("File has been removed")
            } catch {
                print("an error during a removing")
            }
        }
        audioString = ""
        journalName.text = ""
    }
    
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let audioS = audioString, audioS != "", let journalN = journalName.text, journalN != "" {
            let journalNametxt: Dictionary<String, AnyObject> = [
                "journalName": journalName.text! as AnyObject
            ]
            
            let journalContenttxt: Dictionary<String, AnyObject> = [
                "journalContent": "Audio Message Click Image" as AnyObject,
                "audioMessage": audioString!
                
            ]
            
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date1String = dateFormatter.string(from: date as Date)
            
            let journalDatetxt: Dictionary<String, AnyObject> = [
                "journalDate": date1String as AnyObject
            ]
            
            
            let firebasePost = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalName")
            
            let firebasePostReference = firebasePost.childByAutoId()
            firebasePostReference.setValue(journalNametxt)
            
            let firebasePost1 = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalContent")
            let firebasePostReference1 = firebasePost1.childByAutoId()
            firebasePostReference1.setValue(journalContenttxt)
            
            let firebasePost2 = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/JournalDate")
            let firebasePostReference2 = firebasePost2.childByAutoId()
            firebasePostReference2.setValue(journalDatetxt)
            
            showAlert(title: "Journal Status", msg: "Saved!")
            
            
        }
        else {
            showErrorAlert(title: "Fill Required Fields", msg: "Enter Name and Content")
            
        }

    }
    
        
}
