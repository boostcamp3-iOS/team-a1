//
//  TrandDays.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct TrendDays: Codable {
    let trend: Default
    private enum CodingKeys: String, CodingKey {
        case trend = "default"
    }
}

struct Default: Codable {
    let searchesByDays: [TrendingSearchesDay]
    let endDateForNextRequest: String
    let rssFeedPageURL: String
    private enum CodingKeys: String, CodingKey {
        case endDateForNextRequest
        case rssFeedPageURL = "rssFeedPageUrl"
        case searchesByDays = "trendingSearchesDays"
    }
}

struct TrendingSearchesDay: Codable {
    let date, formattedDate: String
    let keywordList: [TrendingSearch]
    private enum CodingKeys: String, CodingKey {
        case date, formattedDate
        case keywordList = "trendingSearches"
    }
}

struct TrendingSearch: Codable {
    let title: Title
    let formattedTraffic: String
    let relatedQueries: [Title]
    let image: Image
    let articles: [KeywordArticles]
    let shareURL: String
    private enum CodingKeys: String, CodingKey {
        case title, formattedTraffic, relatedQueries, image, articles
        case shareURL = "shareUrl"
    }
}

struct KeywordArticles: Codable {
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

struct Title: Codable {
    let query, exploreLink: String
}
