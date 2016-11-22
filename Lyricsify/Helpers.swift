//
//  Helpers.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/22/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import Cocoa

class Helpers {
    public static func executeShellCommand(command: String, args: Array<String>) -> String {
        let pipe = Pipe()
        let process = Process()
        
        process.standardOutput = pipe
        process.launchPath = command
        process.arguments = args
        process.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let response: String = NSString(
            data: data,
            encoding: String.Encoding.utf8.rawValue
            )! as String
        return response
    }
    
    public static func excuteAppleScript(script: String) -> String {
        let response = executeShellCommand(
            command: "/usr/bin/osascript",
            args: ["-e", script]
            ).replacingOccurrences(of: "\n", with: "")
        return response
    }
}
