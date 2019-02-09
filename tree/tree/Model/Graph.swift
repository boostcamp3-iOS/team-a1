//
//  Graph.swift
//  tree
//
//  Created by ParkSungJoon on 06/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct Graph: Codable {
    let startDate, endDate, timeUnit: String
    let results: [KeywordResult]
}

struct KeywordResult: Codable {
    let title: String
    let keywords: [String]
    let data: [Datum]
}

struct Datum: Codable {
    let period: String
    let ratio: Double
}
