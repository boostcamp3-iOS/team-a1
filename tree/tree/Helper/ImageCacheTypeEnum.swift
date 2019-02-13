//
//  ImageCacheTypeEnum.swift
//  tree
//
//  Created by hyeri kim on 11/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum CacheType {
    case memory
    case disk
    case none
    
    var cached: Bool {
        switch self {
        case .memory, .disk: return true
        case .none: return false
        }
    }
}
