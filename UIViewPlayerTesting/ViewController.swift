//
//  ViewController.swift
//  UIViewPlayerTesting
//
//  Created by Kausthubh adhikari on 01/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    var videoView: CGVideoPlayer?
    lazy var muteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        button.setImage(UIImage(systemName: "speaker.slash.fill"), for: .selected)
        button.backgroundColor = UIColor.tertiarySystemGroupedBackground
        return button
    }()

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
    
        videoView = CGVideoPlayer()
        self.view.addSubview(videoView!)
        videoView?.translatesAutoresizingMaskIntoConstraints = false
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        videoView?.addSubview(muteButton)
        
        NSLayoutConstraint.activate( [
            videoView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(sideSpace)),
            videoView!.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(Int(screenHeight - (CGFloat(pipMoviePlayerHeight) + bottomSpace)))),
            videoView!.widthAnchor.constraint(equalToConstant: CGFloat(pipMoviePlayerWidth)),
            videoView!.heightAnchor.constraint(equalToConstant: CGFloat(pipMoviePlayerHeight)),
            muteButton.leadingAnchor.constraint(equalTo: videoView!.leadingAnchor, constant: 5),
            muteButton.topAnchor.constraint(equalTo: videoView!.topAnchor, constant: 5),
            muteButton.heightAnchor.constraint(equalToConstant: 28),
            muteButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        
        muteButton.layer.cornerRadius = 28/2
        muteButton.layer.masksToBounds = true
        
        videoView?.layer.cornerRadius = 18
        videoView?.layer.cornerCurve = .continuous
        videoView?.layer.masksToBounds = true
        videoView?.layer.borderWidth = 2
        videoView?.layer.borderColor = UIColor.separator.cgColor
        
        videoView!.play(with: URL(string: "https://retool-glu-assets.customerglu.com/sdkpip_66f12.mp4")!)
        
        muteButton.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
    }
    
    
    @objc func onButtonTap(_ buttton: UIButton) {
        buttton.isSelected.toggle()
        if buttton.isSelected {
            videoView?.mute()
        } else {
            videoView?.unmute()
        }
    }
}

