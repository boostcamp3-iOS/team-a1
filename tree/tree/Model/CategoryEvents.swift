//
//  CategoryEvents.swift
//  tree
//
//  Created by ParkSungJoon on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

/// Events Data를 Category별로 분류하기 위한 모델입니다.
struct CategoryEvents {
    var category: String
    var events: [ResultInfo]
}
