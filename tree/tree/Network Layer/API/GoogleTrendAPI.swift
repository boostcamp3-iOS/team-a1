//
//  GoogleTrendAPI.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum GoogleTrendAPI {
    case getDailyTrends(hl: String, geo: String)
}

extension GoogleTrendAPI: APIService {
    
    var baseURL: URL {
        guard let url = URL(string: googleTrendAPIBaseURL) else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    var path: String? {
        switch self {
        case .getDailyTrends:
            return "/dailytrends"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDailyTrends:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getDailyTrends(let hl, let geo):
            return ["hl": hl, "geo": geo]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getDailyTrends:
            return .requestWith(url: parameters, body: nil, encoding: .query)
        }
    }
    
    var header: HTTPHeader? {
        return nil
    }
}
