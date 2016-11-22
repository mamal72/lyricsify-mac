//
//  StringTest.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/13/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import XCTest
@testable import Lyricsify

class StringTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStripHtml() {
        let html = "<!DOCTYPE html><html><meta charset=\"UTF-8\"><title>Document</title></html>"
        let strippedHtml = html.stripHtml()
        XCTAssertEqual("Document", strippedHtml)
    }

    func testBreakToNewLine() {
        let html = "<body><p><br>Yes<br>No<br></p></body>"
        let noBreakHtml = html.breakToNewLine()
        XCTAssertEqual("<body><p>\nYes\nNo\n</p></body>", noBreakHtml)
    }

    func testBreakToNewLineAndStripHtml() {
        let html = "<body><p><br>Yes<br>No<br></p></body>"
        let noBreakStrippedHtml = html.breakToNewLine().stripHtml()
        XCTAssertEqual("\nYes\nNo\n", noBreakStrippedHtml)
    }

}
