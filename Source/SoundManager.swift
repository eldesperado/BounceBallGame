//
//  SoundHelper.swift
//  Pinball
//
//  Created by Pham Nguyen Nhat Trung on 9/21/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import Foundation

enum SoundTrack: String {
    case Background, Bounce, GameOver, Won, Boom
    
    func getFilePath() -> String {
        return self.rawValue + ".wav"
    }
}

class SoundManager: NSObject {
    static let sharedInstace = SoundManager()
    let simpleAudio = OALSimpleAudio.sharedInstance()
    
    func preloadSoundTracks() {
        OALSimpleAudio.sharedInstance().preloadEffect(SoundTrack.Bounce.getFilePath())
        OALSimpleAudio.sharedInstance().preloadEffect(SoundTrack.GameOver.getFilePath())
        OALSimpleAudio.sharedInstance().preloadEffect(SoundTrack.Won.getFilePath())
        OALSimpleAudio.sharedInstance().preloadEffect(SoundTrack.Boom.getFilePath())
        
    }
    
    func playBGTrack(track: SoundTrack, volume: Float = 0.8, pan: Float = 0, loop: Bool = true) {
        self.simpleAudio.playBg(track.getFilePath(), volume: volume, pan: pan, loop: loop)
    }
    
    func playEffectTrack(track: SoundTrack, volume: Float = 1, pitch: Float = 1, pan: Float = 0, loop: Bool = false) {
        self.pauseBG()
        self.simpleAudio.playEffect(track.getFilePath(), volume: volume, pitch: pitch, pan: pan, loop: loop)

        let isNeedToPauseBGSound = self.needToPauseBGSound(track)
        if isNeedToPauseBGSound && loop == false {
            let buffer: ALBuffer = OALSimpleAudio.sharedInstance().preloadEffect(track.getFilePath())
            
            // Resume the background sound after finishing playing the effect sound
            let duration: NSTimeInterval = Double(buffer.duration)
            NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "resumeBG", userInfo: nil, repeats: false)
        }
    }
    
    func stopBG() {
        self.simpleAudio.stopBg()
    }
    
    func pauseBG() {
        self.simpleAudio.bgPaused = true
    }
    
    func resumeBG() {
        self.simpleAudio.bgPaused = false
    }

    
    func resumeBGAndStopEffect() {
        self.stopAllEffect()
        self.resumeBG()
    }
    
    func stopAllEffect() {
        self.simpleAudio.stopAllEffects()
    }
    
    func stopEverything() {
        self.simpleAudio.stopEverything()
    }
    
    // MARK: Helpers
    private func needToPauseBGSound(track: SoundTrack) -> Bool {
        switch (track) {
        case .GameOver:
            return true
        case .Won:
            return true
        default:
            return false
        }
    }
    
}
