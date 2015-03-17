//
//  RecordSoundsViewController.swift
//  Pitch Perfect Me
//
//  Created by John Stefanik on 3/15/15.
//  Copyright (c) 2015 John Stefanik. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        // Before view appears, enable record button and hide stop button
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecord.hidden = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func recordAudio(sender: UIButton) {
        // When record button is pressed, record audio
        
        // Setup path to recorded audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        // Create a file name based on date and time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Create an audio session and record audio
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        // Show and hide buttons and labels
        recordButton.enabled = false
        stopButton.hidden = false
        recordingInProgress.hidden = false
        tapToRecord.hidden = true
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // When audio recorder finishes perform the following
        
        if(flag){
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            //Stop recording the users voice
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            tapToRecord.hidden = false
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When segue is performed, pass information to Modeler and PlaySoundsViewController
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    

    @IBAction func stopRecording(sender: UIButton) {
        // When Stop is pressed, stop recording
        
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
}

