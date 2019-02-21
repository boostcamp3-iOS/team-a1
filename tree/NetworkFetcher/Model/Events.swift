//
//  Events.swift
//  tree
//
//  Created by ParkSungJoon on 12/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

public struct Events: Codable {
    public let events: EventsData
}

public struct EventsData: Codable {
    public let results: [ResultInfo]
    public let totalResults, page, count, pages: Int
}

public struct ResultInfo: Codable {
    public let uri, eventDate: String
    public let totalArticleCount: Int
    public let title, summary: [String: String]
    public let location: LocationInfo?
    public let categories: [CategoryInfo]
    public let images: [String]
    public let articleCounts: [String: Int]
    public let socialScore: Double
    public let wgt: Int
}

public struct CategoryInfo: Codable {
    public let uri, label: String
    public let wgt: Int
}

public struct LocationInfo: Codable {
    public let type: String
    public let label: Label
    public let lat, long: Double
    public let country: CountryInfo?
    
    init(type: String, label: Label, lat: Double, long: Double, country: CountryInfo?) {
        self.type = type
        self.label = label
        self.lat = lat
        self.long = long
        self.country = country
    }
}

public struct CountryInfo: Codable {
    public let type: String
    public let label: Label
    public let lat, long: Double
    
    init(type: String, label: Label, lat: Double, long: Double) {
        self.type = type
        self.label = label
        self.lat = lat
        self.long = long
    }
}

public struct Label: Codable {
    public let eng: String
}

public struct Summary: Codable {
    public let eng, rus, por, spa: String?
    public let deu, fra, tur, ukr: String?
    public let zho, hrv, ita, ind: String?
    public let vie: String?
}
