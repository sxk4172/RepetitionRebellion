//
//  AudioMessage.swift
//  Repetition Rebellion
//
//  Created by Sanika Kulkarni on 3/28/16.
//  Copyright © 2016 Repetition Rebellion. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class AudioMessage: UIViewController, AVAudioRecorderDelegate , UITextFieldDelegate {

    var audioFilename: String!
    var temp = true
    @IBOutlet weak var sendToUsername: UITextField!
    var audioPlayer = AVAudioPlayer()
    var audioURL: NSURL? = nil
    var audioData: NSData? = nil
    var audioString: String? = nil
    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func play(_ sender: Any) {
        if let audio = audioURL {
            audioData = NSData(contentsOf: audio as URL)
            audioString = audioData!.base64EncodedString(options: [])
            do {
                try  audioPlayer = AVAudioPlayer(data: audioData! as Data)
                audioPlayer.volume = 1.0
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                print("playing")
                
            }
            catch {
            }
        }

    }

    
    @IBAction func send(_ sender: Any) {
        if let audioS = audioString, audioS != "", let sendUserN = sendToUsername.text, sendUserN != "" {
            let AES = CryptoJS.AES()
            let encrypted = AES.encrypt(audioS, password: "password123")
            
            
            let mess: Dictionary<String, AnyObject> = [
                "textMessage": "Audio Message Click Image" as AnyObject,
                "audioMessage": encrypted as AnyObject
            ]
            
            print(UserDefaults.standard.value(forKey: "USERNAMEID")!)
            
            let usersname: Dictionary<String,AnyObject> = [
                "username": UserDefaults.standard.value(forKey:"USERNAMEID")! as AnyObject
            ]
            
            let firebasePost = DataService.ds.REF_Messages.childByAutoId()
            firebasePost.setValue(mess)
            
            
            //current user
            let _REF_Users_Uid_ALLMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey:KEY_ID)!)/allMessages")
            
            let userMessRef = _REF_Users_Uid_ALLMessage.child(byAppendingPath: firebasePost.key)
            userMessRef.observeSingleEvent(of: .value, with: { snapshot in
                if (snapshot.value as? NSNull) != nil{
                    userMessRef.setValue(true)
                }
                
            })
            
            let _REF_Users_Uid_sentMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/messageSent")
            
            let userMessSentRef = _REF_Users_Uid_sentMessage.child(byAppendingPath: firebasePost.key)
            userMessSentRef.observeSingleEvent(of: .value, with: { snapshot in
                if (snapshot.value as? NSNull) != nil{
                    userMessSentRef.setValue(true)
                }
                
            })
            
            
            let users: Dictionary<String,AnyObject> = [
                "username": "Me" as AnyObject
            ]
            
            let _PREF_Users_ALLMessage_Username = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(UserDefaults.standard.value(forKey: KEY_ID)!)/messageUsername")
            
            let usernameMessRef = _PREF_Users_ALLMessage_Username.childByAutoId()
            usernameMessRef.setValue(users)
            
            //receiver user
            
            DataService.ds.REF_Users.observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    for snap in snapshots {
                        if let usersDict = snap.value as? Dictionary<String, AnyObject> {
                            let userN = Users(userKey: snap.key, dictionary: usersDict)
                            if self.sendToUsername.text!.uppercased() == userN.username! {
                                
                                let key = snap.key
                                let _REF_ReceiveUsers_Uid_ALLMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(key)/allMessages")
                                
                                let receiveuserMessRef = _REF_ReceiveUsers_Uid_ALLMessage.child(byAppendingPath: firebasePost.key)
                                receiveuserMessRef.observeSingleEvent(of: .value, with: { snapshot in
                                    if (snapshot.value as? NSNull) != nil{
                                        receiveuserMessRef.setValue(true)
                                    }
                                    
                                })
                                
                                let _REF_receiveUsers_Uid_receiveMessage = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(key)/messageReceived")
                                
                                let receiveuserMessSentRef = _REF_receiveUsers_Uid_receiveMessage.child(byAppendingPath: firebasePost.key)
                                receiveuserMessSentRef.observeSingleEvent(of: .value, with: { snapshot in
                                    if (snapshot.value as? NSNull) != nil{
                                        receiveuserMessSentRef.setValue(true)
                                    }
                                    
                                })
                                
                                
                                let _PREF_UsersReceive_ALLMessage_Username = FIRDatabase.database().reference(fromURL: "https://repetitionrebellion.firebaseio.com/Users/\(key)/messageUsername")
                                
                                let usernameMessReceive = _PREF_UsersReceive_ALLMessage_Username.childByAutoId()
                                usernameMessReceive.observeSingleEvent(of: .value, with: { snapshot in
                                    if (snapshot.value as? NSNull) != nil{
                                        if(self.temp == true) {
                                            usernameMessReceive.setValue(usersname)
                                            self.temp = false
                                            print("Checking if bool false")
                                            self.showAlert(title: "Audio Message Status", msg: "Message Sent!")
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                
                
            })
            
            
            
        }
            
        else {
            showErrorAlert(title: "Error", msg: "Record Message Failed! Try Again! ")
        }
        

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
        sendToUsername.text = ""
    }
    
    
    
    func showErrorAlert (title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendToUsername.delegate = self
        
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
            audioRecorder = try AVAudioRecorder(url: audioURL! as URL, settings: settings)
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
        recordButton.addTarget(self, action: #selector(AudioMessage.recordTapped), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
}
