//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by 홍진표 on 10/13/23.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerViewDataSource: AnyObject {
    
    // MARK: - Stored-Props
    var currentTrackObjectURL: URL? { get }
    var currentTrackObjectName: String? { get }
    var currentTrackObjectSubTitle: String? { get }
}

final class PlaybackPresenter {
    
    // MARK: - Singleton Instance
    static let shared: PlaybackPresenter = PlaybackPresenter()
    
    // MARK: - Stored-Props
    private var track: TrackObject?
    private var tracks: [TrackObject] = [TrackObject]()
    
    private var player: AVPlayer? = nil
    private var playerQueue: AVQueuePlayer? = nil
    
    private var playerViewController: PlayerViewController? = nil
    private var index: Int = 0
    
    // MARK: - Computed-Prop
    var currentTrack: TrackObject? {
        if let track: TrackObject = track, tracks.isEmpty {
            return track
        } else if let playerQueue: AVQueuePlayer = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        
        return nil
    }
    
    // MARK: - Method
    func startPlayback<T>(from viewController: UIViewController, data model: T) -> Void {
        
        let playerVC: PlayerViewController = PlayerViewController()
        
        switch model {
        case let trackObject as TrackObject:
            playerVC.dataSource = self
            playerVC.delegate = self
            
            self.track = trackObject
            self.tracks = []
            
            guard let preview_url: URL = URL(string: trackObject.preview_url ?? "") else { return }
            
            player = AVPlayer(url: preview_url)
            player?.volume = 0.5
            player?.play()
            
            playerVC.title = trackObject.name
            viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
            
            self.playerViewController = playerVC
            break;
        case let trackObjects as [TrackObject]:
            playerVC.dataSource = self
            playerVC.delegate = self
            
            self.track = nil
            self.tracks = trackObjects
            
            self.playerQueue = AVQueuePlayer(items: trackObjects.compactMap({
                guard let preview_url: URL = URL(string: $0.preview_url ?? "") else { return nil }
                
                return AVPlayerItem(url: preview_url)
            }))
            self.playerQueue?.volume = 0.5
            self.playerQueue?.play()
            
            playerVC.title = trackObjects.first?.name
            viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
            
            self.playerViewController = playerVC
            break;
        default:
            break;
        }
    }
}

extension PlaybackPresenter: PlayerViewDataSource, PlayerViewControllerDelegate {
    
    // MARK: - PlayerViewDataSource Stored-Props Implementation
    var currentTrackObjectURL: URL? { return URL(string: currentTrack?.album.images.first?.url ?? "") }
    var currentTrackObjectName: String? { return currentTrack?.name }
    var currentTrackObjectSubTitle: String? { return currentTrack?.artists.first?.name }
    
    // MARK: - PlayerViewControllerDelegate Methods Implementation
    func didTapPause() {
        
        if let player: AVPlayer = player {
            if (player.timeControlStatus == .playing) {
                player.pause()
            } else if (player.timeControlStatus == .paused) {
                player.play()
            }
        } else if let playerQueue: AVQueuePlayer = playerQueue {
            if (playerQueue.timeControlStatus == .playing) {
                playerQueue.pause()
            } else if (playerQueue.timeControlStatus == .paused) {
                playerQueue.play()
            }
        }
    }
    
    func didTapBackward() {
        
        if (tracks.isEmpty == true) {
            player?.pause()
            player?.play()
        } else if let firstItem: AVPlayerItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerViewController?.refreshUI()
        }
    }
    
    func didTapForward() {
        
        if (tracks.isEmpty == true) {
            player?.pause()
        } else if let playerQueue: AVQueuePlayer = playerQueue {
            playerQueue.advanceToNextItem()
            guard (index < tracks.count - 1) else { return }
            index += 1
            playerViewController?.refreshUI()
        }
    }
    
    func didSlideSlider(args value: Float) {
        
        player?.volume = value
    }
}
