//
//  ExtractAPI.swift
//  tree
//
//  Created by hyeri kim on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum ExtractAPI {
    case extractArticleInfo(url: String)
}

extension ExtractAPI: APIService {
    var baseURL: URL {
        guard let url = URL(string: extractAPIBaseURL) else { fatalError("Invalid URL") }
        return url
    }
    
    var path: String? {
        switch self {
        case .extractArticleInfo:
            return "/api/v1/extractArticleInfo"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .extractArticleInfo:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .extractArticleInfo(let url):
            return [
                "url": url,
                "apiKey": APIConstant.eventRegistryKey
            ]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .extractArticleInfo:
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
