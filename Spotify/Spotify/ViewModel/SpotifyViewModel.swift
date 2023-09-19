//
//  SpotifyViewModel.swift
//  Spotify
//
//  Created by 홍진표 on 2023/09/10.
//

import Foundation

final class SpotifyViewModel {
    
    // MARK: - Stored-Props
    let users: UsersViewModel
    let albums: NewReleasesViewModel
    let playlists: PlaylistsViewModel
    let tracks: TracksViewModel
    
    // MARK: - Init
    init() {
        self.users = UsersViewModel()
        self.albums = NewReleasesViewModel()
        self.playlists = PlaylistsViewModel()
        self.tracks = TracksViewModel()
    }
}
