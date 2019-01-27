//
//  EventRegistryAPI.swift
//  tree
//
//  Created by ParkSungJoon on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

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
            let articlesPage):
            return [
                "keyword": keyword,
                "keywordLoc": keywordLoc,
                "lang": lang,
                "articlesSortBy": articlesSortBy,
                "articlesPage": articlesPage,
                "action": "getArticles",
                "resultType": "articles",
                "articlesCount": 20,
                "includeArticleImage": true,
                "articleBodyLen": -1,
                "apiKey": "553fab57-e89f-4a1c-8941-3dcb37cf7e30"
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
