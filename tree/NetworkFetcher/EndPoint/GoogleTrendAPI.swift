//
//  GoogleTrendAPI.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation
import Booster

public enum GoogleTrendAPI {
    case fetchDailyTrends(hl: String, geo: String)
}

extension GoogleTrendAPI: BoosterService {
    
    public var baseURL: URL {
        guard let url = URL(string: BaseURL.googleTrendAPIBaseURL) else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    public var path: String? {
        switch self {
        case .fetchDailyTrends:
            return "/dailytrends"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchDailyTrends:
            return .get
        }
    }
    
    public var parameters: Parameters {
        switch self {
        case .fetchDailyTrends(let hl, let geo):
            return ["hl": hl, "geo": geo]
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .fetchDailyTrends:
            return .requestWith(url: parameters, body: nil, encoding: .query)
        }
    }
    
    public var header: HTTPHeader? {
        return nil
    }
}
