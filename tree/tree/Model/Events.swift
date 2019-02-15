//
//  Events.swift
//  tree
//
//  Created by ParkSungJoon on 12/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct Events: Codable {
    let events: EventsData
}

struct EventsData: Codable {
    let results: [ResultInfo]
    let totalResults, page, count, pages: Int
}

struct ResultInfo: Codable {
    let uri, eventDate: String
    let totalArticleCount: Int
    let title, summary: [String: String]
    let location: LocationInfo?
    let categories: [CategoryInfo]
    let images: [String]
    let articleCounts: [String: Int]
    let socialScore: Double
    let wgt: Int
}

struct CategoryInfo: Codable {
    let uri, label: String
    let wgt: Int
}

struct LocationInfo: Codable {
    let type: String
    let label: Label
    let lat, long: Double
    let country: CountryInfo?
    
    init(type: String, label: Label, lat: Double, long: Double, country: CountryInfo?) {
        self.type = type
        self.label = label
        self.lat = lat
        self.long = long
        self.country = country
    }
}

struct CountryInfo: Codable {
    let type: String
    let label: Label
    let lat, long: Double
    
    init(type: String, label: Label, lat: Double, long: Double) {
        self.type = type
        self.label = label
        self.lat = lat
        self.long = long
    }
}

struct Label: Codable {
    let eng: String
}

struct Summary: Codable {
    let eng, rus, por, spa: String?
    let deu, fra, tur, ukr: String?
    let zho, hrv, ita, ind: String?
    let vie: String?
}
