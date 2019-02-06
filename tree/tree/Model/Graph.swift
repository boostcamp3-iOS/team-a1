//
//  Graph.swift
//  tree
//
//  Created by ParkSungJoon on 06/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct Graph: Codable {
    let graphDefault: KeywordInterestRate
    
    private enum CodingKeys: String, CodingKey {
        case graphDefault = "default"
    }
}

struct KeywordInterestRate: Codable {
    let timelineData: [TimelineDatum]
}

struct TimelineDatum: Codable {
    let time, formattedTime, formattedAxisTime: String
    let value: [Int]
    let hasData: [Bool]
    let formattedValue: [String]
}
