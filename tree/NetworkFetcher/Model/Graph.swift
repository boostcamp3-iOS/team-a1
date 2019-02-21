//
//  Graph.swift
//  tree
//
//  Created by ParkSungJoon on 06/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

public struct Graph: Codable {
    public let startDate, endDate, timeUnit: String
    public let results: [KeywordResult]
}

public struct KeywordResult: Codable {
    public let title: String
    public let keywords: [String]
    public let data: [Datum]
}

public struct Datum: Codable {
    public let period: String
    public let ratio: Double
}
