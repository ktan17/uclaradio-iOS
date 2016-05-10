//
//  AudioStream.swift
//  UCLA Radio
//
//  Created by Christopher Laganiere on 5/2/16.
//  Copyright © 2016 ChrisLaganiere. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioStream: NSObject {
    
    static let sharedInstance = AudioStream()
    
    var playing = false
    
    private var audioPlayer = AVPlayer(URL: NSURL(string: "http://stream.uclaradio.com:8000/listen")!)
    
    // prevents others from using default '()' initializer for this class
    private override init () {
        super.init()

        // Set up AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        audioPlayer.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .New, context: nil)
        audioPlayer.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .New, context: nil)
        
        updateNowPlaying()
    }
    
    func play() {
        if (audioPlayer.status == .ReadyToPlay && !playing) {
            audioPlayer.play()
            playing = true
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        }
    }
    
    func pause() {
        if (playing) {
            audioPlayer.pause()
            playing = false
        }
    }
    
    func skipToLive() {
        let newItem = AVPlayerItem(URL: NSURL(string: "http://stream.uclaradio.com:8000/listen")!)
        audioPlayer.replaceCurrentItemWithPlayerItem(newItem)
        if playing {
            audioPlayer.play()
        }
    }
    
    func updateNowPlaying() {
        var nowPlayingDict: [String: AnyObject] = [:]
        nowPlayingDict[MPMediaItemPropertyArtist] = "UCLA Radio"
        nowPlayingDict[MPMediaItemPropertyTitle] = "Pirate Radio"
        nowPlayingDict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingDict
    }
    
    func printData() {
        let item = audioPlayer.currentItem
        print("duration: \(item?.duration)")
        print("timebase: \(item?.timebase)")
        print("loadedTimeRanges: \(item?.loadedTimeRanges)")
        print("currentDate: \(item?.currentDate())")
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let player = object as? AVPlayer {
            if keyPath == "playbackBufferEmpty" {
                if let empty = player.currentItem?.playbackBufferEmpty where empty {
                    player.play()
                    print("playbackBufferEmpty")
                }
                else {
                    print("playbackBuffer not Empty")
                }
            }
            else if keyPath == "playbackLikelyToKeepUp" {
                print("playbackLikelyToKeepUp")
            }
        }
    }
    
}
