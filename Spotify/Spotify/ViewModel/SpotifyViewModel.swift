//
//  SpotifyViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/10.
//

import Foundation

final class SpotifyViewModel {
    
    // MARK: - Stored-Props
    let album: AlbumViewModel
    let albums: NewReleasesViewModel
    let playlists: PlaylistsViewModel
    let tracks: TracksViewModel
    let users: UsersViewModel
    
    // MARK: - Init
    init() {
        
        self.album = AlbumViewModel()
        self.albums = NewReleasesViewModel()
        self.playlists = PlaylistsViewModel()
        self.tracks = TracksViewModel()
        self.users = UsersViewModel()
    }
}
