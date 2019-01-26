//
//  Articles.swift
//  tree
//
//  Created by ParkSungJoon on 23/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct Articles: Codable {
    let articles: Results
}

struct Results: Codable {
    let results: [Article]
}

struct Article: Codable {
    let uri: String
    let lang: String
    let date: String
    let time: String
    let sim: Double
    let url: String
    let title: String
    let body: String
    let source: Source
    let author: [Author]?
    let image: String?
    
    private enum CodingKeys: String, CodingKey {
        case uri, lang, date, time
        case sim, url, title, body, source, image
        case author = "authors"
    }
}

struct Source: Codable {
    let uri: String
    let dataType: String
    let title: String
}

struct Author: Codable {
    let uri: String
    let name: String
    let type: String
    let isAgency: Bool
}
