//
//  SpotifyHelpersTest.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/13/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import XCTest
import Darwin
@testable import Lyricsify

class SpotifyHelpersTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    func testIsSpotifyRunning() {
        let _ = Helpers.excuteAppleScript(script: "tell application \"Spotify\" to quit")
        sleep(5)
        XCTAssertFalse(SpotifyHelpers.isSpotifyRunning())
    }

}
