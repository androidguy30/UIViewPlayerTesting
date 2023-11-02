//
//  ViewController.swift
//  UIViewPlayerTesting
//
//  Created by Kausthubh adhikari on 01/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    var videoView: PiPMediaPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenRect = UIScreen.main.bounds
        var screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        screenWidth = screenWidth * 0.40
        let widthPer  = screenWidth
        let heightPer = 1.78 * screenWidth
        
        
        let bottomSpace = (screenHeight * 5)/100
        let sideSpace = Int((screenWidth * 5)/100)
        let topSpace = Int((screenHeight * 5)/100)
        
        screenWidth = screenWidth * 0.40
        
        let pipMoviePlayerHeight = Int(heightPer)
        let pipMoviePlayerWidth = Int(widthPer)
    
        videoView = PiPMediaPlayer()
        self.view.addSubview(videoView!)
        
        videoView!.frame = CGRect(x: sideSpace, y: Int(screenHeight - (CGFloat(pipMoviePlayerHeight) + bottomSpace)), width: pipMoviePlayerWidth, height: pipMoviePlayerHeight)
        
        videoView!.setupPlayer()
    }


    override func viewDidLayoutSubviews() {
        if let videoView = videoView{
            videoView.updatePlayerBounds()
        }
        
    }
    
}

