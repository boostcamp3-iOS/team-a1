//
//  NaverAPI.swift
//  tree
//
//  Created by ParkSungJoon on 07/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation
import Booster

public enum NaverAPIMode {
    case fetchKeywordGraphData(
        startDate: String,
        endDate: String,
        timeUnit: String,
        keywordGroups: [Parameters]
    )
}

extension NaverAPIMode: BoosterService {

    public var baseURL: URL {
        guard let url = URL(string: BaseURL.naverAPIBaseURL) else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    public var path: String? {
        switch self {
        case .fetchKeywordGraphData:
            return nil
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchKeywordGraphData:
            return .post
        }
    }
    
    public var parameters: Parameters {
        switch self {
        case .fetchKeywordGraphData(let startDate, let endDate, let timeUnit, let keywordGroups):
            return [
                "startDate": startDate,
                "endDate": endDate,
                "timeUnit": timeUnit,
                "keywordGroups": keywordGroups
            ]
        }
    }
    
    public var task: HTTPTask {
        switch self {
        case .fetchKeywordGraphData:
            return .requestWith(url: nil, body: parameters, encoding: .body)
        }
    }
    
    public var header: HTTPHeader? {
        switch self {
        case .fetchKeywordGraphData:
            return [
                .naverClientID: APIConstant.naverClientID,
                .naverClientSecret: APIConstant.naverClientSecret
            ]
        }
    }
}
