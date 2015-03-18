//
//  RecordSoundsViewController.swift
//  Pitch Perfect (Udacity)
//
//  Created by Benji on 3/10/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var instructLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    //MARK: - Variables
    var isRecording: Bool!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    //MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //Set up UI
        instructLabel.text = "Tap to Record"
        stopRecordingButton.hidden = true
        playPauseButton.hidden = true
        
        isRecording = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -

    @IBAction func recordAction(sender: UIButton) {
        //Show text "Recording in Progress"
        instructLabel.text = "Recording in Progress"
        
        //Show stopRecordingButton and playPauseButton
        stopRecordingButton.hidden = false
        playPauseButton.hidden = false
        
        //Create a path to record the audio to.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Create a date object to name the audiofile, and assign that name to the audio file array.
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Set up the audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Set up audioRecorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        
        //Record Audio
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        isRecording = true
    }
    
    //If audioRecorder isRecording, change the button to the play button and pause the recording. Else, do the opposite.
    @IBAction func playPauseAction(sender: UIButton) {
        if isRecording == true {
            sender.setImage(UIImage(named: "play"), forState: .Normal)
            audioRecorder.pause()
            isRecording = false
        } else if isRecording == false {
            sender.setImage(UIImage(named: "pause"), forState: .Normal)
            audioRecorder.record()
            isRecording = true
        }
    }
    
    //Stops recorder, sets audioSession to false.
    @IBAction func stopAction(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        isRecording = false
    }
    
    
    //MARK: - Audio Recorder Flag
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        //If recording was successful, create a filePath and perform segue to Play screen. Else, reset all UI.
        if flag {
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePath: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            isRecording = false
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopRecordingButton.hidden = true
            isRecording = false
        }
    }
    
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }

}

