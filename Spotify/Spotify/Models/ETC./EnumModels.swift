//
//  EnumModels.swift
//  Spotify
//
//  Created by 홍진표 on 10/10/23.
//

import Foundation

enum HomeSectionType {
    case newReleases(albums_items: [CommonGroundModel.SimplifiedAlbum]?)
    case featuredPlaylists(playlists_items: [CommonGroundModel.SimplifiedPlaylist]?)
    case recommendations(tracks: [TrackObject]?)
    
    var headerTitle: String {
        get {
            switch self {
            case .newReleases:
                return "New Releases";
            case .featuredPlaylists:
                return "Featured Playlists";
            case .recommendations:
                return "Recommendations";
            }
        }
    }
}

enum SearchResult {
    case track(track: TrackObject?)
    case artist(artist: CommonGroundModel.ArtistObject?)
    case album(album: CommonGroundModel.SimplifiedAlbum?)
    case playlist(playlist: CommonGroundModel.SimplifiedPlaylist?)
    case show(show: CommonGroundModel.SimplifiedShow?)
    case audiobook(audiobook: SearchResponse.Audiobook.SimplifiedAudiobookObject?)
}
