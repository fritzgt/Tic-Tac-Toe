//
//  Sounds.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/20/21.
//

import AVFoundation

struct SoundsPlayer {
    
    var audioPlayer: AVAudioPlayer?
    
    mutating func playSound(sound: String, type: String, isSoundEnable: Bool) {
        if !isSoundEnable { return }//Dont rung if sound is disable
        
        if let path = Bundle.main.path(forResource: sound, ofType: type)  {
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            }catch {
                print("Error: Could not play sound file")
            }
        }
    }
    
}
