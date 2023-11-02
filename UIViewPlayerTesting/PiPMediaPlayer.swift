//
//  PiPMediaPlayer.swift
//  UIViewPlayerTesting
//
//  Created by Kausthubh adhikari on 01/11/23.
//

import Foundation
import UIKit
import AVFoundation
import EVPlayer

class PiPMediaPlayer : UIView {
    
    var player: AVPlayer?
    var playerVideoLayer: CALayer?
    
      override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
          playerVideoLayer?.frame = self.bounds
      }
    
    
    func setupPlayer(){
        
        self.backgroundColor = .green
        do {
            let videoPath = "https://retool-glu-assets.customerglu.com/sdkpip_66f12.mp4"
            
            let videoPathURL = URL(fileURLWithPath: videoPath)
            
            self.player = AVPlayer(url: videoPathURL)
            playerVideoLayer = AVPlayerLayer(player: player)
            
            self.playerVideoLayer?.frame = self.bounds
           
            self.layer.addSublayer(playerVideoLayer!)
            self.player?.play()
           
        }catch {
            print(error)
        }
        
        
        
        
        
        
        
        
//        let player = Player()
//        player.view.frame = self.bounds
//
//        self.backgroundColor = .black
//
//        self.addSubview(player)
//        player.url = URL(string: "https://retool-glu-assets.customerglu.com/sdkpip_66f12.mp4")!
//        player.fillMode = .resizeAspectFill
//        player.autoplay = true
//        player.playbackLoops = true
//        player.volume = 1.0
//        player.playFromBeginning()
        
        
     
//        let evPlayer = EVPlayer(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))
//        self.addSubview(evPlayer)
//        evPlayer.clipsToBounds = true
//        evPlayer.frame = self.bounds
//        evPlayer.center = self.center
//
//        let media = EVMedia(videoURL: URL(string: "https://retool-glu-assets.customerglu.com/sdkpip_66f12.mp4")!,
//                                   thumbnailURL: URL(fileURLWithPath: Bundle.main.path(forResource: "defaultThumbnail2", ofType: "png") ?? ""))
//
//        var config = EVConfiguration(media: media)
//        config.shouldAutoPlay = true
//        config.shouldLoopVideo = true
//        config.videoGravity = .resizeAspectFill
//        evPlayer.load(with: config)
        
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
        self.playerVideoLayer?.frame = self.bounds
      }
    
    func updatePlayerBounds(){
    
    }
    
}
