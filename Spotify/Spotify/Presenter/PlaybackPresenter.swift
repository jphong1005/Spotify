//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by 홍진표 on 10/13/23.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    
    // MARK: - Method
    static func startPlayback<T>(from viewController: UIViewController, data model: T) -> Void {
        
        let playerVC: PlayerViewController = PlayerViewController()
        
        switch model {
        case let _ as TrackObject:
            viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
            break;
        case let _ as [TrackObject]:
            viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
            break;
        case let _ as Album.Track.SimplifiedTrack:
            viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
            break;
        case let _ as [Album.Track.SimplifiedTrack]:
            viewController.present(UINavigationController(rootViewController: playerVC), animated: true)
            break;
        default:
            break;
        }
    }
}
