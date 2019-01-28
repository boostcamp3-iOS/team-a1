//
//  EventRegistryAPI.swift
//  tree
//
//  Created by ParkSungJoon on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

private enum DefaultParameter {
    case apiKey
    case articleBodyLen
    case includeArticleImage
    case articlesCount
    case resultType
    case action
}

extension DefaultParameter {
    var value: Any {
        switch self {
        case .apiKey: return "553fab57-e89f-4a1c-8941-3dcb37cf7e30"
        case .articleBodyLen: return -1
        case .includeArticleImage: return true
        case .articlesCount: return 20
        case .resultType: return "articles"
        case .action: return "getArticles"
        }
    }
}

enum EventRegistryAPI {
    case getArticles(
        keyword: String,
        keywordLoc: String,
        lang: String,
        articlesSortBy: String,
        articlesPage: Int
    )
}

extension EventRegistryAPI: APIService {
    var baseURL: URL {
        guard let url = URL(string: "http://eventregistry.org") else { fatalError("Invalid URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .getArticles:
            return "/api/v1/article"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getArticles:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getArticles(
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
                "articleBodyLen": DefaultParameter.articleBodyLen.value,
                "apiKey": DefaultParameter.apiKey.value
            ]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getArticles:
            return .requestWith(
                url: parameters,
                body: nil,
                encoding: .query
            )
        }
    }
}
