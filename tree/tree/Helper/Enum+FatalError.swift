//
//  Enum+FatalErrorMessage.swift
//  tree
//
//  Created by ParkSungJoon on 16/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum FatalError: Error {
    case invalidCell
    case nilData
    
    var localizedDescription: String {
        switch self {
        case .invalidCell: return "유효하지 않은 Cell타입입니다."
        case .nilData: return "Data가 nil입니다."
        }
    }
}
