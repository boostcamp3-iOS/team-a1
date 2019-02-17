//
//  NaverAPI.swift
//  tree
//
//  Created by ParkSungJoon on 07/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum NaverAPIMode {
    case keywordTrend(
        startDate: String,
        endDate: String,
        timeUnit: String,
        keywordGroups: [Parameters]
    )
}

extension NaverAPIMode: APIService {

    var baseURL: URL {
        guard let url = URL(string: naverAPIBaseURL) else {
            fatalError("Invalid URL")
        }
        return url
    }
    
    var path: String? {
        switch self {
        case .keywordTrend:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .keywordTrend:
            return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .keywordTrend(let startDate, let endDate, let timeUnit, let keywordGroups):
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
        case .keywordTrend:
            return .requestWith(url: nil, body: parameters, encoding: .body)
        }
    }
    
    var header: HTTPHeader? {
        switch self {
        case .keywordTrend:
            return [
                .naverClientID: APIConstant.naverClientID,
                .naverClientSecret: APIConstant.naverClientSecret
            ]
        }
    }
}
