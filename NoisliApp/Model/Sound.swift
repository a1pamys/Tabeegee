//
//  Sound.swift
//  NoisliApp
//
//  Created by a1pamys on 3/5/18.
//  Copyright © 2018 Алпамыс. All rights reserved.
//

import Foundation
import AVFoundation

struct Sound {
    
    var soundName: String?
    var audioPlayer: AVAudioPlayer?
    var prepareToPlay: Bool?
    var thumbnailImage: String?
    var soundDuration: Int?
    var volume: Float! {
        set {
            self.audioPlayer?.setVolume(newValue, fadeDuration: 1)
        }
        get {
            return self.audioPlayer?.volume
        }
    }
    
    init(soundName: String?, audioPlayer: AVAudioPlayer?, prepareToPlay: Bool?, thumbnailImage: String?, soundDuration: Int?){
        self.soundName = soundName
        self.audioPlayer = audioPlayer
        self.prepareToPlay = prepareToPlay
        self.thumbnailImage = thumbnailImage
        self.soundDuration = soundDuration
    }
    
    static func getSounds() -> [Sound] {
        var sounds: [Sound] = []
        let soundNames = ["rain", "storm", "moon", "fire", "sea"]
        do {
            for soundName in soundNames {
                let audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!))
//                audioPlayer.numberOfLoops = -1
                sounds.append(Sound(soundName: soundName, audioPlayer: audioPlayer, prepareToPlay: true, thumbnailImage: "\(soundName)-w", soundDuration: Int(audioPlayer.duration)))
            }
        } catch {
            print(error)
        }
        
        return sounds
    }
}
