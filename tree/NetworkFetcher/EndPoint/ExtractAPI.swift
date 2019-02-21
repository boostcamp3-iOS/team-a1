//
//  ExtractAPI.swift
//  tree
//
//  Created by hyeri kim on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation
import Booster

public enum ExtractAPI {
    case extractArticleInfo(url: String)
}

extension ExtractAPI: BoosterService {
    public var baseURL: URL {
        guard let url = URL(string: BaseURL.extractAPIBaseURL) else { fatalError("Invalid URL") }
        return url
    }
    
    public var path: String? {
        switch self {
        case .extractArticleInfo:
            return "/api/v1/extractArticleInfo"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .extractArticleInfo:
            return .get
        }
    }
    
    public var parameters: Parameters {
        switch self {
        case .extractArticleInfo(let url):
            return [
                "url": url,
                "apiKey": APIConstant.eventRegistryKey
            ]
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .extractArticleInfo:
            return .requestWith(
                url: parameters, 
                body: nil,
                encoding: .query
            )
        }
    }
    
    public var header: HTTPHeader? {
        return nil
    }    
}
