//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Mickael Eriksson on 2015-05-11.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {
    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var recordingOutlet: UILabel!
    @IBOutlet weak var stopButtonOutlet: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var recordedAudio:RecordedAudio!;
    var timer = NSTimer();
   
    //
    // Fires before view shows.
    //
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.stopButtonOutlet.hidden = true;
        self.recordButton.enabled=true;
        self.recordingOutlet.text="Tap to Record";
        self.recordingOutlet.hidden=false;
    }

    //
    // Function that starts and records audio from mic.
    //
    @IBAction func recordAudio(sender: AnyObject) {
        println("In recording");
        
        self.recordingOutlet.hidden = false;
        self.stopButtonOutlet.hidden = false;
        self.recordButton.enabled=false;
        timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self,
            selector: "updateLabel", userInfo: nil, repeats: true);
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as! String;
        let currentDateTime = NSDate();
        let formatter = NSDateFormatter();
        formatter.dateFormat = "ddMMyyyy-HHmmss";
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav";
        let pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        println(filePath);
        
        var session = AVAudioSession.sharedInstance();
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil);
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil);
        audioRecorder.delegate=self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record();
    }
    
    //
    // Function that stops the recording session.
    //
   
    @IBAction func stopButtonAction(sender: AnyObject) {
        self.recordingOutlet.hidden = true;
        self.stopButtonOutlet.hidden = true;
        self.recordButton.enabled=true;
        self.timer.invalidate();
        audioRecorder.stop();
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil);
    }
    //
    //Fires when recoding has ended. And inits seuge.
    //
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,title: recorder.url.lastPathComponent!);
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        }else {
            println("Rercording was not successfull")
            self.recordingOutlet.text="Tap to Record";
            recordButton.enabled = true;
            stopButtonOutlet.hidden = true;
        }
    }
    //
    //Fires before segue is executed.
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "StopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data;
        }
    }
    //
    // Function that makes a label flashing.
    //
    func updateLabel() {
       recordingOutlet.text="Recording";
        if (self.recordingOutlet.hidden ){
            self.recordingOutlet.hidden=false
        }
        else{
            self.recordingOutlet.hidden=true
        }
    }
}

