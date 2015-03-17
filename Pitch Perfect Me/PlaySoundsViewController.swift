//
//  PlaySoundsViewController.swift
//  Pitch Perfect Me
//
//  Created by John Stefanik on 3/15/15.
//  Copyright (c) 2015 John Stefanik. All rights reserved.
//

import UIKit
import AVFoundation



class PlaySoundsViewController: UIViewController {

    // Declared Globally
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.


        // Initialize audioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Initialize audioEngine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func playMyAudio(myRate: Float) {
        // Play audio at rate myRate
        
        // Stop and reset audio player and audio engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.rate = myRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        // Play audio with variable pitch
        
        // Stop and reset audio player and audio engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Attach an instance of AVAudioPlayerNode to AVAudioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Attach an instance of AVAudioUnitTimePitch to AVAudioEngine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect them to each other
        audioEngine.connect(audioPlayerNode, to:changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to:audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        // Stop audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    @IBAction func playAudioFast(sender: UIButton) {
        // Play audio fast
        playMyAudio(2.0)
    }
    

    @IBAction func playAudioSlow(sender: UIButton) {
        // Play audio slowly
        playMyAudio(0.5)
    }

    
    @IBAction func playAudioHigh(sender: UIButton) {
        // When chipmunk button is pressed, play audio high like a chipmunk
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // When darthvader button is pressed, play audio low like darth vader
        playAudioWithVariablePitch(-1000)}
}
