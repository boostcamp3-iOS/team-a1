//
//  Enum+TimeIntervalTypes.swift
//  tree
//
//  Created by ParkSungJoon on 08/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum TimeIntervalTypes {
    case oneDay
    case oneMonth
    
    var value: TimeInterval {
        switch self {
        case .oneDay: return TimeInterval(86400)
        case .oneMonth: return TimeInterval(30 * 86400)
        }
    }
}
