//
//  HelpersTest.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/13/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import XCTest
@testable import Lyricsify

class HelpersTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExecuteShellCommand() {
        let stdoutResponse = Helpers.executeShellCommand(
            command: "/usr/bin/osascript",
            args: ["-e", "get \"lyricsify\" as string"]
        )
        XCTAssertEqual("lyricsify\n", stdoutResponse)
    }

    func testExcuteAppleScript() {
        let response = Helpers.excuteAppleScript(script: "get \"Lyricsify Rocks!\" as string")
        XCTAssertEqual("Lyricsify Rocks!", response)
    }

}
