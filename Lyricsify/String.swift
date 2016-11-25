//
//  String.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/22/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

extension String {
    func stripHtml() -> String {
        let htmlReplaceString = "<[^>]+>"
        return self.replacingOccurrences(
            of: htmlReplaceString,
            with: "",
            options: String.CompareOptions.regularExpression,
            range: nil
        )
    }

    func breakToNewLine() -> String {
        return self.replacingOccurrences(of: "<br>", with: "\n")
    }
}
