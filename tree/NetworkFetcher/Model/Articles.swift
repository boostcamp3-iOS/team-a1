//
//  Articles.swift
//  tree
//
//  Created by ParkSungJoon on 23/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

public struct Articles: Codable {
    public let articles: Results
}

public struct Results: Codable {
    public let page: Int
    public let totalResults: Int
    public let pages: Int
    public let results: [Article]
}

public struct Article: Codable {
    public let uri: String
    public let lang: String
    public let date: String
    public let time: String
    public let sim: Double
    public let url: String
    public let title: String
    public let body: String
    public let source: Source
    public let author: [Author]?
    public let image: String?
    public let categories: [Category]
    
    private enum CodingKeys: String, CodingKey {
        case uri, lang, date, time, categories
        case sim, url, title, body, source, image
        case author = "authors"
    }
}

public struct Category: Codable {
    public let uri: String
    public let label: String
    public let wgt: Int
}

public struct Source: Codable {
    public let uri: String
    public let dataType: String
    public let title: String
}

public struct Author: Codable {
    public let uri: String
    public let name: String
    public let type: String
    public let isAgency: Bool
}
