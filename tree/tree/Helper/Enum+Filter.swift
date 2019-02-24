//
//  Enum+Filter.swift
//  tree
//
//  Created by hyeri kim on 21/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum SearchFilter {
    case keyword 
    case sort 
    case category 
    case language 
    
    var stringValue: String {
        return "\(self)"
    }

}
