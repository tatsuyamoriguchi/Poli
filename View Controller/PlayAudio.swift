//
//  PlayAudio.swift
//  PoliPoli
//
//  Created by Tatsuya Moriguchi on 8/6/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PlayAudio {
    static let sharedInstance = PlayAudio()
    private var player: AVAudioPlayer!
 
    func playClick(fileName: String, fileExt: String) {
        //guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExt) else {return}
        
        if let asset = NSDataAsset(name: fileName) {
            
            do {
                /*
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: <#AVAudioSession.Mode#>)
 */
                try AVAudioSession.sharedInstance().setActive(true)
                
                //player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                player = try AVAudioPlayer(data:asset.data, fileTypeHint: "caf")
                guard let player = player else { return }
                player.play()
            } catch {
                print(error)
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
