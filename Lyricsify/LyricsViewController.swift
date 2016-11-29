//
//  LyricsViewController.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/22/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import Cocoa

class LyricsViewController: NSViewController {

    @IBOutlet weak var trackTitleView: NSTextField!
    @IBOutlet weak var trackLyricsView: NSTextField!
    @IBOutlet weak var trackProgressView: NSProgressIndicator!
    @IBOutlet weak var playerProgressView: NSSlider!

    var nowPlayingTimer = Timer()

    @IBAction func playerProgressChange(_ sender: NSSlider) {
        if let nowPlayingTrack = SpotifyHelpers.getNowPlaying() {
            nowPlayingTrack.position = Int(Double(playerProgressView.stringValue)!)
        }
    }

    @IBAction func playerToggle(_ sender: NSButton) {
        SpotifyHelpers.togglePlayingState()
    }

    @IBAction func playerNext(_ sender: NSButton) {
        SpotifyHelpers.nextTrack()
    }

    @IBAction func playerPrevious(_ sender: NSButton) {
        SpotifyHelpers.previousTrack()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
    }

    override func viewWillAppear() {
        startTimer()
    }

    override func viewWillDisappear() {
        stopTimer()
    }

    @objc private func checkNowPlaying(_: Timer) {
        if let nowPlayingTrack = SpotifyHelpers.getNowPlaying() {
            self.playerProgressView.stringValue = String(nowPlayingTrack.position)
            if
                nowPlayingTrack.title != "" &&
                nowPlayingTrack.title != self.trackTitleView.stringValue {
                self.loadTrack(track: nowPlayingTrack)
            }
        } else {
            self.spotifyIsNotRunning()
        }
    }

    func spotifyIsNotRunning() {
        self.setTrackTitle(title: "Spotify is not running!")
        self.setTrackLyrics(lyrics: "")
    }

    func setTrackTitle(title: String) {
        self.trackTitleView.stringValue = title
        self.trackTitleView.isHidden = false
    }

    func setTrackLyrics(lyrics: String) {
        self.trackLyricsView.stringValue = lyrics
        self.trackLyricsView.isHidden = false
    }

    func loadTrack(track: Track) {
        self.setTrackTitle(title: track.title)
        self.playerProgressView.maxValue = Double(track.duration)
        track.onLyricsChanged = { lyrics in
            self.setTrackLyrics(lyrics: track.lyrics!)
            self.showLyricsView()
        }
        track.loadLyrics()
        self.hideLyricsView()
    }

    func showLyricsView() {
        trackProgressView.stopAnimation(nil)
        self.trackLyricsView.isHidden = false
        self.trackTitleView.isHidden = false
        trackProgressView.isHidden = true
    }

    func hideLyricsView() {
        trackProgressView.startAnimation(nil)
        trackProgressView.isHidden = false
        self.trackLyricsView.isHidden = true
        self.trackTitleView.isHidden = true
    }

    func startTimer(runOnceImmediately: Bool = true) {
        if nowPlayingTimer.isValid {
            return
        }

        if runOnceImmediately {
            self.checkNowPlaying(self.nowPlayingTimer)
        }

        if #available(OSX 10.12, *) {
            nowPlayingTimer = Timer.scheduledTimer(
                withTimeInterval: 4,
                repeats: true,
                block: self.checkNowPlaying
            )
        } else {
            nowPlayingTimer = Timer.scheduledTimer(
                timeInterval: 4,
                target: self,
                selector: #selector(self.checkNowPlaying),
                userInfo: nil,
                repeats: true
            )
        }
    }

    func stopTimer() {
        if nowPlayingTimer.isValid {
            nowPlayingTimer.invalidate()
        }
    }
}
