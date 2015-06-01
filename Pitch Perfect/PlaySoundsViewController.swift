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

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.delegate = self

        audioEngine = AVAudioEngine()
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
        stopButton.enabled = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    func playAudioWithVariableRate(rate: Float) {
        stopButton.enabled = true
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.play()
    }

    func playAudioWithVariablePitch(pitch: Float) {
        stopButton.enabled = true

        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        stopButton.enabled = false
    }

}
