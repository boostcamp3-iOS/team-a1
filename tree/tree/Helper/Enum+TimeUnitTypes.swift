//
//  Enum+TimeUnitTypes.swift
//  tree
//
//  Created by ParkSungJoon on 08/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum TimeUnitTypes {
    case week
    case month
    case year
    
    var value: String {
        switch self {
        case .week: return "week"
        case .month: return "month"
        case .year: return "year"
        }
    }
}
