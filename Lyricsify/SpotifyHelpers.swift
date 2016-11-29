//
//  SpotifyHelpers.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/22/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

enum PlayingState {
    case playing
    case notPlaying
}

class SpotifyHelpers {
    static func tellSpotify(command: String) -> String {
        let response = Helpers.excuteAppleScript(
            script: "tell application \"Spotify\" to \(command) as string"
        )
        return response
    }

    static func getSomethingOfCurrentTrack(thing: String) -> String {
        return tellSpotify(
            command: "\(thing) of current track"
            ).replacingOccurrences(
                of: "\n", with: ""
        )
    }

    static func getNowPlaying() -> Track? {
        if !self.isSpotifyRunning() {
            return nil
        }
        return Track()
    }

    static func getPlayerState() -> PlayingState? {
        if !self.isSpotifyRunning() {
            return nil
        }

        let playingState = tellSpotify(command: "player state")
        if playingState == "playing" {
            return PlayingState.playing
        }
        return PlayingState.notPlaying
    }

    static func togglePlayingState() {
        if !self.isSpotifyRunning() {
            return
        }

        _ = tellSpotify(command: "playpause")
    }

    static func nextTrack() {
        if !self.isSpotifyRunning() {
            return
        }

        _ = tellSpotify(command: "next track")
    }

    static func previousTrack() {
        if !self.isSpotifyRunning() {
            return
        }

        // _ = tellSpotify(command: "set player position to 0")
        _ = tellSpotify(command: "previous track")
    }

    static func isSpotifyRunning() -> Bool {
        return Helpers.excuteAppleScript(script: "application \"Spotify\" is running") == "true"
    }
}
