//
//  AudioCaptureViewController.swift
//  Audio Capture and Playback
//
//  Created by Chris Rehagen on 3/10/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit
import AVKit

class AudioCaptureViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var playAndPauseButton: UIBarButtonItem!
    
    var recording = false
    var playing = false
    
    var audioSession: AVAudioSession? = AVAudioSession.sharedInstance()
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var audioFile: URL!
    

    
    let recordingSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
         AVEncoderBitRateKey: 16,
         AVNumberOfChannelsKey: 2,
         AVSampleRateKey: 44100.0] as [String : Any]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        playAndPauseButton.isEnabled = false
                
        audioSession!.requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                self.recordButton.isEnabled = true
                
            }
        
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if !recording {
                   do {
                       recorder = try AVAudioRecorder(url: audioFile, settings: recordingSettings)
                       recorder?.delegate = self
                       recorder?.record()
                       //button1.image = UIImage(named: "stop")
                       recording = true
                   } catch {
                       
                   }
               } else {
                   recording = false
               }
            
    }
    
    @IBAction func playAndPauseButtonPressed(_ sender: Any) {
        if !playing {
            do {
                player = try AVAudioPlayer(contentsOf: audioFile, fileTypeHint: AVFileType.mp4.rawValue)
                player?.delegate = self
                player?.prepareToPlay()
                player?.play()
                playing = true
            } catch {
                displayError(error.localizedDescription)
                print(error)
            }
        } else {
            playing = false
            player?.stop()
            player = nil
            //button2.image = UIImage(named: "play")
            //button1.isEnabled = true
        }
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    
   
    
}
