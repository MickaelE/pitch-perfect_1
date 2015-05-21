//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Mickael Eriksson on 2015-05-13.
//  Copyright (c) 2015 Mickenet. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!;
    var audioPlayer2:AVAudioPlayer!;
    var reverbPlayers:[AVAudioPlayer] = []
    var recievedAudio:RecordedAudio!;
    let unitReverb = AVAudioUnitReverb()
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL:recievedAudio.filePathUrl, error:nil);
        audioPlayer2 = AVAudioPlayer(contentsOfURL:recievedAudio.filePathUrl, error:nil); //Used for Echo, no need for rate enabled.
        audioPlayer.enableRate = true;
        audioEngine = AVAudioEngine();
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil);
    }

    @IBAction func fastButtonAction(sender: AnyObject) {
        println("FastButton");
        playAudioWithVariableSpeed(2.0);
    }
    
    @IBAction func slowButtonAction(sender: AnyObject) {
        println("slowButton");
        playAudioWithVariableSpeed(0.5);
    }
  
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        println("chipmunkButton");
        playAudioWithVariablePitch(1000);
    }
    
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
        println("dathvaderButton");
        playAudioWithVariablePitch(-1000);
    }
    
    @IBAction func playReverbAudio(sender: AnyObject) {
        println("reverbButton");
        stopAllAudio();
        var inputNode: AVAudioInputNode!
        inputNode = audioEngine.inputNode
        audioEngine.attachNode(unitReverb)
        
        let format = unitReverb.inputFormatForBus(0)
        audioEngine.connect(inputNode, to: unitReverb, format: format)
        audioEngine.connect(unitReverb, to: audioEngine.outputNode, format: format)
        
        audioEngine.startAndReturnError(nil)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        println("echoButton");
        playEcho(0.1);//100ms
    }
    
    @IBAction func stopPlayingAction(sender: AnyObject) {
       stopAllAudio();
    }
    
    //
    // Function to play sound with eco. Supply intervall between echo.
    //
    func playEcho(delay:NSTimeInterval){
        stopAllAudio();
        audioPlayer.play()
        var playtime:NSTimeInterval;
        playtime = audioPlayer.deviceCurrentTime + delay;
        audioPlayer.currentTime=0;
        audioPlayer2.currentTime=0;
        audioPlayer2.playAtTime(playtime);
        
    }
    
    //
    //Function to play sound with variable pitch. Supply pitch.
    //
    func playAudioWithVariablePitch(pitch: Float) {
      stopAllAudio();
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitch = AVAudioUnitTimePitch()
        changePitch.pitch = pitch
        audioEngine.attachNode(changePitch)
        audioEngine.connect(audioPlayerNode, to: changePitch, format: nil)
        audioEngine.connect(changePitch, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    //
    // Function to play with variable rate. Supplying rate.
    //
    func playAudioWithVariableSpeed(speed:Float){
        stopAllAudio();
        audioPlayer.currentTime=0;
        audioPlayer.rate = speed;
        audioPlayer.play();
    }
    //
    // Function to stop all sound.
    //
    func stopAllAudio(){
        if(audioEngine.running){
            audioEngine.stop();
            audioEngine.reset();
        }
        audioPlayer.stop();
        audioPlayer.currentTime=0;
        audioPlayer2.stop();
        audioPlayer2.currentTime=0;
    }
   
}
