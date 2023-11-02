//
//  CGVideoPlayer.swift
//  UIViewPlayerTesting
//
//  Created by Amit Samant on 03/11/23.
//

import UIKit
import AVFoundation
import OSLog


public enum CGMediaPlayerScreenTimeBehaviour {
    case keepSystemIdleBehaviour
    case preventFromIdle
}
public enum CGMediaPlayingBehaviour {
    case autoPlayOnLoad
    case playOnDemand
}

public class CGVideoPlayer: UIView {
    
    public override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    public var player: AVPlayer? {
        get { playerLayer.player }
        set {
            playerLayer.player = newValue
        }
    }
    
    public var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    
    private var playerItemContext = 0
    private var playerItem: AVPlayerItem?
    private var mediaPlayingBehaviour: CGMediaPlayingBehaviour = .playOnDemand
    private var screenTimeBehaviour: CGMediaPlayerScreenTimeBehaviour = .keepSystemIdleBehaviour
    
    // One of the value from here containing the actual playable media in avassets
    // Read more: https://developer.apple.com/documentation/avfoundation/avasset?language=objc
    private let assetValueKey = "playable"
    
    
    /// Load asset for given url
    /// - Parameters:
    ///   - url: URL to load asset from
    ///   - completion: completion called once the media is been loaded
    private func loadAsset(with url: URL, completion: @escaping (_ asset: AVAsset) -> Void) {
        // Added otherwise video sound would be silenced by system in case of silent mode is enabled
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        let asset = AVAsset(url: url)
        asset.loadValuesAsynchronously(forKeys: ["playable"]) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                self.logInfo("Successfully loaded media from url %{PUBLIC}@", url.absoluteString)
                completion(asset)
            case .failed:
                self.logError("Failed to load media from url %{PUBLIC}@", url.absoluteString)
            case .cancelled:
                self.logError("Media loading was cancelled for url %{PUBLIC}@", url.absoluteString)
            default:
                self.logError("Undefined status observed while loading for url %{PUBLIC}@", url.absoluteString)
            }
        }
    }
    
    /// Updates the current player item to reflect new media asset
    /// - Parameter asset: asset to update/play
    private func updatePlayerItem(with asset: AVAsset) {
        playerItem = AVPlayerItem(asset: asset)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
        DispatchQueue.main.async { [weak self] in
            self?.player = AVPlayer(playerItem: self?.playerItem!)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
            
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                self.logInfo("Ready to play media")
                playIfBehaviourAllowsOnLoad()
            case .failed:
                self.logError("Failed to play media")
            case .unknown:
                self.logError("Unknown status recieved while playing the media")
            @unknown default:
                self.logError("Unknown status recieved while playing the media")
            }
        }
    }
    
    private func playIfBehaviourAllowsOnLoad() {
        switch mediaPlayingBehaviour {
        case .autoPlayOnLoad:
            player?.play()
        case .playOnDemand:
            break
        }
    }
    
    private func setPrefferedScreenTimeBehaviour() {
        switch screenTimeBehaviour {
        case .keepSystemIdleBehaviour:
            UIApplication.shared.isIdleTimerDisabled = false
        case .preventFromIdle:
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    /// Starts loading the media associated with given url, and optinally plays it once loaded
    /// - Parameters:
    ///   - url: URL of media file
    ///   - behaviour: Media behaviour that controlls the plyaback on load.
    public func play(
        with url: URL,
        behaviour: CGMediaPlayingBehaviour = .autoPlayOnLoad,
        screenTimeBehaviour: CGMediaPlayerScreenTimeBehaviour = .preventFromIdle
    ) {
        self.mediaPlayingBehaviour = behaviour
        self.screenTimeBehaviour = screenTimeBehaviour
        loadAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.updatePlayerItem(with: asset)
        }
    }
    
    /// Starts loading the media associated with given url, and optinally plays it once loaded
    /// - Parameters:
    ///   - url: URL of media file
    ///   - behaviour: Media behaviour that controlls the plyaback on load.
    public func play(
        with filePath: String,
        behaviour: CGMediaPlayingBehaviour = .autoPlayOnLoad,
        screenTimeBehaviour: CGMediaPlayerScreenTimeBehaviour = .preventFromIdle
    ) {
        self.mediaPlayingBehaviour = behaviour
        self.screenTimeBehaviour = screenTimeBehaviour
        let url = URL(fileURLWithPath: filePath)
        loadAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.updatePlayerItem(with: asset)
        }
    }
    
    /// Starts loading the media associated with given url, and optinally plays it once loaded
    /// - Parameters:
    ///   - url: URL of media file
    ///   - behaviour: Media behaviour that controlls the plyaback on load.
    public func play(
        bundleResource resource: String,
        withExtension extension: String?,
        bundle: Bundle = .main,
        behaviour: CGMediaPlayingBehaviour = .autoPlayOnLoad,
        screenTimeBehaviour: CGMediaPlayerScreenTimeBehaviour = .preventFromIdle
    ) {
        guard let url = bundle.url(forResource: resource, withExtension: `extension`) else {
            logError("Unable to locate %{PUBLIC}@ with extension %{PUBLIC}@ in bundle", resource, (`extension` ?? "N/A"))
            return
        }
        self.mediaPlayingBehaviour = behaviour
        self.screenTimeBehaviour = screenTimeBehaviour
        loadAsset(with: url) { [weak self] (asset: AVAsset) in
            self?.updatePlayerItem(with: asset)
        }
    }
    
    public func resume() {
        player?.rate = 1.1
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func mute() {
        player?.isMuted = true
    }
    
    public func unmute() {
        player?.isMuted = false
    }
    
    //MARK: - Logging
    #if DEBUG
    private let log = OSLog(subsystem: "com.customerglu.CGVideoPlayer", category: "VideoPlayer")
    #endif

    private func logInfo(_ message: StaticString, _ args: CVarArg...) {
        #if DEBUG
        os_log(message, log: log, type: .info, args)
        #endif
    }

    private func logError(_ message: StaticString, _ args: CVarArg...) {
        #if DEBUG
        os_log(message, log: log, type: .error, args)
        #endif
    }
    
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: &playerItemContext)
    }
    
}
