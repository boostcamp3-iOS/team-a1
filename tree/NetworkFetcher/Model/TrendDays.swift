//
//  TrandDays.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

public struct TrendDays: Codable {
    public let trend: Default
    private enum CodingKeys: String, CodingKey {
        case trend = "default"
    }
}

public struct Default: Codable {
    public let searchesByDays: [TrendingSearchesDay]
    public let endDateForNextRequest: String
    public let rssFeedPageURL: String
    private enum CodingKeys: String, CodingKey {
        case endDateForNextRequest
        case rssFeedPageURL = "rssFeedPageUrl"
        case searchesByDays = "trendingSearchesDays"
    }
}

public struct TrendingSearchesDay: Codable {
    public let date, formattedDate: String
    public let keywordList: [TrendingSearch]
    private enum CodingKeys: String, CodingKey {
        case date, formattedDate
        case keywordList = "trendingSearches"
    }
}

public struct TrendingSearch: Codable {
    public let title: Title
    public let formattedTraffic: String
    public let relatedQueries: [Title]
    public let image: Image
    public let articles: [KeywordArticles]
    public let shareURL: String
    private enum CodingKeys: String, CodingKey {
        case title, formattedTraffic, relatedQueries, image, articles
        case shareURL = "shareUrl"
    }
}

public struct KeywordArticles: Codable {
    public let title, timeAgo, source: String
    public let image: Image?
    public let url: String
    public let snippet: String
}

public struct Image: Codable {
    public let newsURL: String
    public let source: String
    public let imageURL: String
    private enum CodingKeys: String, CodingKey {
        case newsURL = "newsUrl"
        case source
        case imageURL = "imageUrl"
    }
}

public struct Title: Codable {
    public let query, exploreLink: String
}
