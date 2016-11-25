//
//  Track.swift
//  Lyricsify
//
//  Created by Mohamad Jahani on 11/22/16.
//  Copyright © 2016 Mohamad Jahani. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Kanna

class Track {
    public var artist: String
    public var album: String
    public var name: String
    public var lyrics: String?
    public var onLyricsChanged: ((String) -> Void)?

    public var title: String {
        get {
            if self.artist != "" && self.lyrics != "" {
                return "\(self.artist) - \(self.name)"
            }
            return ""
        }
    }

    private let searchApiUri = "http://lyrics.wikia.com/index.php"
    private let lyricsUriPath = "http://lyrics.wikia.com/wiki/"

    private func getSearchRequestParams(query: String) -> Parameters {
        return [
            "action": "ajax",
            "rs": "getLinkSuggest",
            "format": "json",
            "query": query
        ]
    }

    private func getLyricsUriPath(trackTitle: String) -> String {
        return "\(lyricsUriPath)\(trackTitle)"
    }

    init(artist: String, album: String, name: String) {
        self.artist = artist
        self.album = album
        self.name = name
    }

    init() {
        self.artist = SpotifyHelpers.getSomethingOfCurrentTrack(thing: "artist")
        self.album = SpotifyHelpers.getSomethingOfCurrentTrack(thing: "album")
        self.name = SpotifyHelpers.getSomethingOfCurrentTrack(thing: "name")
    }

    private func fetchLyrics(
        trackTitle: String,
        success: ((String) -> Void)?,
        failure: ((Error) -> Void)?,
        done: (() -> Void)?
        ) -> Void {
        let path = getLyricsUriPath(
            trackTitle: trackTitle
            ).addingPercentEncoding(
                withAllowedCharacters: NSCharacterSet.urlQueryAllowed
        )
        Alamofire
            .request(path!)
            .responseString { response in
                switch response.result {
                case .success(let data):
                    if let doc = HTML(html: data, encoding: .utf8) {
                        let lyricsBox = doc.css(".lyricbox").first
                        let lyricsHtml = lyricsBox?.innerHTML!
                        let lyricsText = lyricsHtml?
                            .breakToNewLine()
                            .stripHtml()
                        if lyricsText != nil, let finalText = String(lyricsText!) {
                            success!(finalText)
                        } else {
                            success!("Error getting lyrics for \(self.artist) - \(self.name)! 😮")
                        }
                    }
                case .failure(let err):
                    failure!(err)
                }
                done!()
        }
    }

    public func searchForLyrics(
        success: ((Array<String>) -> Void)?,
        failure: ((Error) -> Void)?
        ) -> Void {
        Alamofire
            .request(
                searchApiUri,
                parameters: getSearchRequestParams(
                    query: "\(self.artist) \(self.name)"
                )
            )
            .validate()
            .responseJSON {response in
                switch response.result {
                case .success(let data):
                    let jsonData = JSON(data)
                    let suggestions = jsonData["suggestions"].arrayValue.map({$0.stringValue})
                    success!(suggestions)
                case .failure(let err):
                    failure!(err)
                }
        }
    }

    public func loadLyrics() -> Void {
        let previousLyrics = self.lyrics

        searchForLyrics(success: { lyricsList in
            if lyricsList.count == 0 {
                self.lyrics = "No lyrics found for \(self.artist) - \(self.name)! ☹️"
                self.onLyricsChanged!(self.lyrics!)
            } else {
                self.lyrics = "Found \(lyricsList.count) lyrics for \(self.artist) - \(self.name)!"
                let trackTitle = lyricsList.first!
                self.fetchLyrics(trackTitle: trackTitle, success: { newLyrics in
                    self.lyrics = newLyrics
                }, failure: { err in
                    self.lyrics = "Error getting lyrics for \(self.artist) - \(self.name)! 😮"
                    self.onLyricsChanged!(self.lyrics!)
                }, done: {
                    if previousLyrics != self.lyrics {
                        self.onLyricsChanged!(self.lyrics!)
                    }
                })
            }
        }, failure: { err in
            self.lyrics = "Error getting lyrics for \(self.artist) - \(self.name)! 😮"
            self.onLyricsChanged!(self.lyrics!)
        })
    }
}
