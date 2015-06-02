//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Pete Castillo on 5/29/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var stopButton: UIButton!

    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    var receivedAudio: RecordedAudio!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Create module level audioPlayer
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true

        // this class will be a delegate for catching events
        audioPlayer.delegate = self

        // Create module level audioEngine
        audioEngine = AVAudioEngine()

        // This is the recorded file that we will play
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        stopButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //
    }

    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }

    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func stop(sender: UIButton) {
        stopPlayer(false)
    }

    func stopPlayer(enableStopButton: Bool) {
        // Stop player and audio engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

        // Enable/disable the stop button
        stopButton.enabled = enableStopButton
    }

    func playAudioWithVariableRate(rate: Float) {

        stopPlayer(true)

        // change rate and play
        audioPlayer.rate = rate
        audioPlayer.play()
    }

    func playAudioWithVariablePitch(pitch: Float) {
        stopPlayer(true)

        // Genereate the player node so we can attach to engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        // This object lets you change the pitch.  create and attach to engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)

        // Connect playerNode to changePitchEffect and 
        // the changePitchEffect to the audioEngines output node
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        // Set the audioFile to the player node and start audio engine
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        // Play the given file
        audioPlayerNode.play()
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // when finished disable stop button
        stopButton.enabled = false
    }

}
