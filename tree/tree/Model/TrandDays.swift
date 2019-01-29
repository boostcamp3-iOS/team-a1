//
//  TrandDays.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct TrandDays: Codable {
    let trandDaysDefault: Default
    
    private enum CodingKeys: String, CodingKey {
        case trandDaysDefault = "default"
    }
}

struct Default: Codable {
    let trendingSearchesDays: [TrendingSearchesDay]
    let endDateForNextRequest: String
    let rssFeedPageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case trendingSearchesDays, endDateForNextRequest
        case rssFeedPageURL = "rssFeedPageUrl"
    }
}

struct TrendingSearchesDay: Codable {
    let date, formattedDate: String
    let trendingSearches: [TrendingSearch]
}

struct TrendingSearch: Codable {
    let title: Title
    let formattedTraffic: FormattedTraffic
    let relatedQueries: [Title]
    let image: Image
    let articles: [Articlea]
    let shareURL: String
    
    private enum CodingKeys: String, CodingKey {
        case title, formattedTraffic, relatedQueries, image, articles
        case shareURL = "shareUrl"
    }
}

struct Articlea: Codable {
    let title, timeAgo, source: String
    let image: Image?
    let url: String
    let snippet: String
}

struct Image: Codable {
    let newsURL: String
    let source: String
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case newsURL = "newsUrl"
        case source
        case imageURL = "imageUrl"
    }
}

enum FormattedTraffic: String, Codable {
    case the10만 = "10만+"
    case the20만 = "20만+"
    case the2만 = "2만+"
    case the50만 = "50만+"
}

struct Title: Codable {
    let query, exploreLink: String
}
