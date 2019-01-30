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
    case getRealTimeTrends
}

extension GoogleTrendAPI: APIService {
    var baseURL: URL {
        guard let url = URL(string: "https://trends.google.com/trends/api") else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getDailyTrends:
            return "/dailytrends"
        case .getRealTimeTrends:
            return "/realtimetrends"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDailyTrends:
            return .get
        case .getRealTimeTrends:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getDailyTrends(let hl, let geo):
            return ["hl": hl, "geo": geo]
        case .getRealTimeTrends:
            return [:]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getDailyTrends:
            return .requestWith(url: parameters, body: nil, encoding: .query)
        case .getRealTimeTrends:
            return .requestWith(url: parameters, body: nil, encoding: .query)
        }
    }
}
