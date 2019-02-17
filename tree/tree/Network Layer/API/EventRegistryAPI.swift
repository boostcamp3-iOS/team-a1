//
//  EventRegistryAPI.swift
//  tree
//
//  Created by ParkSungJoon on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

private enum DefaultParameter {
    case articleBodyLen
    case includeArticleImage
    case includeArticleCategories
    case articlesCount
    case resultType
    case action
    case eventsCount
    case includeEventConcepts
    case language
}

extension DefaultParameter {
    var value: Any {
        switch self {
        case .articleBodyLen: return -1
        case .includeArticleImage: return true
        case .includeArticleCategories: return true
        case .articlesCount: return 20
        case .resultType: return "articles"
        case .action: return "getArticles"
        case .eventsCount: return 50
        case .includeEventConcepts: return false
        case .language: return "eng"
        }
    }
}

enum EventRegistryAPI {
    case fetchArticles(
        keyword: String,
        keywordLoc: String,
        lang: String,
        articlesSortBy: String,
        articlesPage: Int
    )
    case fetchRecentEvents(
        eventPages: Int
    )
}

extension EventRegistryAPI: APIService {
    
    var baseURL: URL {
        guard let url = URL(string: BaseURL.eventRegistryAPIBaseURL) else { fatalError("Invalid URL") }
        return url
    }
    
    var path: String? {
        switch self {
        case .fetchArticles:
            return "/api/v1/article"
        case .fetchRecentEvents:
            return "/api/v1/topRecentEvents"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchArticles:
            return .get
        case .fetchRecentEvents:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .fetchArticles(
            let keyword,
            let keywordLoc,
            let lang,
            let articlesSortBy,
            let articlesPage
            ):
            return [
                "keyword": keyword,
                "keywordLoc": keywordLoc,
                "lang": lang,
                "articlesSortBy": articlesSortBy,
                "articlesPage": articlesPage,
                "action": DefaultParameter.action.value,
                "resultType": DefaultParameter.resultType.value,
                "articlesCount": DefaultParameter.articlesCount.value,
                "includeArticleImage": DefaultParameter.includeArticleImage.value,
                "includeArticleCategories": DefaultParameter.includeArticleCategories.value,
                "articleBodyLen": DefaultParameter.articleBodyLen.value,
                "apiKey": APIConstant.eventRegistryKey
            ]
        case .fetchRecentEvents(
            let eventPages
            ):
            return [
                "eventPages": eventPages,
                "includeEventConcepts": DefaultParameter.includeEventConcepts.value,
                "eventsCount": DefaultParameter.eventsCount.value
            ]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchArticles:
            return .requestWith(
                url: parameters,
                body: nil,
                encoding: .query
            )
        case .fetchRecentEvents:
            return .requestWith(
                url: parameters,
                body: nil,
                encoding: .query
            )
        }
    }
    
    var header: HTTPHeader? {
        return nil
    }
}
