//
//  PlaySoundsViewController.swift
//  Pitch Perfect (Udacity)
//
//  Created by Benji on 3/13/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//
//  This Controller is designed to display a set of buttons, and play the audio recorded on RecordAudioViewController with
//  varying effects.

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //MARK: - Declarations
    
    var audioPlayer: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    
    //MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up audioEngine with file recieved from RecordSoundViewController
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePath, error: nil)
        
        //Set up audioPlayer with file recieved from RecordSoundViewController
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePath, error: nil)
        audioPlayer.enableRate = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: - Action Outlets
    
    //Each connected to corresponding buttons on IB
    
    @IBAction func slowAudioAction(sender: UIButton) {
        playAudioWithVariablePitch(0.5)
    }
    
    @IBAction func fastAudioAction(sender: UIButton) {
        playAudioWithVariablePitch(2.0)
    }
    
    @IBAction func chipmunkAudioAction(sender: UIButton) {
        playAudioWithVariablePitch(2000)
    }
    
    @IBAction func darthVaderAudioAction(sender: UIButton) {
        playAudioWithVariablePitch(-2000)
    }
    
    @IBAction func delayAudioAction(sender: UIButton) {
        var interval = NSTimeInterval()
        interval = 0.3
        playAudioWithVariableDelay(interval)
    }
    
    @IBAction func reverbAudioAction(sender: UIButton) {
        playAudioWithVariableReverb(75)
    }
    
    @IBAction func stopAction(sender: UIButton) {
        stopPlayback()
    }
    
    
    //MARK: - Audio Effect Functions
    
    //Reusable func to stop all playback.
    func stopPlayback() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariableSpeed(speed: Float) {
        stopPlayback()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    //Change pitch of audio playing back.
    func playAudioWithVariablePitch(pitch: Float) {
        stopPlayback()
        
        //Set up a Node to hold the audio file to be played and point it at the engine.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Set up pitch morphing node to change pitch and point it at the engine.
        var pitchVariable = AVAudioUnitTimePitch()
        pitchVariable.pitch = pitch
        audioEngine.attachNode(pitchVariable)
        
        //Connect the audio player, to the effect, to the output for sound to play.
        audioEngine.connect(audioPlayerNode, to: pitchVariable, format: nil)
        audioEngine.connect(pitchVariable, to: audioEngine.outputNode, format: nil)
        
        //Apply the audio to the player node and play the file.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableDelay(delay: NSTimeInterval) {
        stopPlayback()
        
        //Set up a Node to hold the audio file to be played and point it at the engine.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Set up delay effect node to add delay to audio, and point it at the engine.
        var delayVariable = AVAudioUnitDelay()
        delayVariable.delayTime = delay
        audioEngine.attachNode(delayVariable)
        
        //Connect the audio player, to the effect, to the output for sound to play.
        audioEngine.connect(audioPlayerNode, to: delayVariable, format: nil)
        audioEngine.connect(delayVariable, to: audioEngine.outputNode, format: nil)
        
        //Apply the audio to the player node and play the file.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableReverb(reverb: Float) {
        stopPlayback()
        
        //Set up a Node to hold the audio file to be played and point it at the engine.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Set up reverb effect node to add reverb to audio, and point it at the engine.
        var reverbVariable = AVAudioUnitReverb()
        reverbVariable.wetDryMix = reverb
        audioEngine.attachNode(reverbVariable)
        
        //Connect the audio player, to the effect, to the output for sound to play.
        audioEngine.connect(audioPlayerNode, to: reverbVariable, format: nil)
        audioEngine.connect(reverbVariable, to: audioEngine.outputNode, format: nil)
        
        //Apply the audio to the player node and play the file.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
