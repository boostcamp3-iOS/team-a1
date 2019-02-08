//
//  NaverAPI.swift
//  tree
//
//  Created by ParkSungJoon on 07/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum NaverAPI {
    case getKeywordTrend(
        startDate: String,
        endDate: String,
        timeUnit: String,
        keywordGroups: [Parameters]
    )
}

extension NaverAPI: APIService {

    var baseURL: URL {
        guard let url = URL(string: "https://openapi.naver.com/v1/datalab/search") else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    var path: String? {
        switch self {
        case .getKeywordTrend:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getKeywordTrend:
            return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getKeywordTrend(let startDate, let endDate, let timeUnit, let keywordGroups):
            return [
                "startDate": startDate,
                "endDate": endDate,
                "timeUnit": timeUnit,
                "keywordGroups": keywordGroups
            ]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getKeywordTrend:
            return .requestWith(url: nil, body: parameters, encoding: .body)
        }
    }
    
    var header: HTTPHeader? {
        switch self {
        case .getKeywordTrend:
            return [
                .naverClientID: APIConstant.naverClientID,
                .naverClientSecret: APIConstant.naverClientSecret
            ]
        }
    }
}
