//
//  TrackTest.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/9/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import XCTest
import Alamofire
@testable import Lyricsify

class TrackTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    private func getTestTrack() -> Track {
        let data = [
            "artist": "Blackfield",
            "album": "Blackfield",
            "name": "Cloudy Now"
        ]
        return Track(
            artist: data["artist"]!, album: data["album"]!, name: data["name"]!
        )
    }

    func testInitTrack() {
        let data = [
            "artist": "Blackfield",
            "album": "Blackfield",
            "name": "Cloudy Now"
        ]
        let track = Track(artist: data["artist"]!, album: data["album"]!, name: data["name"]!)
        XCTAssertEqual(data["artist"]!, track.artist)
        XCTAssertEqual(data["album"]!, track.album)
        XCTAssertEqual(data["name"]!, track.name)
        XCTAssertNil(track.lyrics)
    }

    func testTrackTitle() {
        let track = getTestTrack()
        XCTAssertEqual(track.title, "\(track.artist) - \(track.name)")

        track.artist = ""
        track.name = ""
        XCTAssertEqual(track.title, "")
    }
}
