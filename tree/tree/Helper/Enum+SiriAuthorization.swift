//
//  Enum+SiriAuthorization.swift
//  tree
//
//  Created by ParkSungJoon on 17/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum SiriAuthorization {
    case denied
    case restricted
    
    var title: String {
        switch self {
        case .denied: return "Siri 권한 거부"
        case .restricted: return "Siri 제한"
        }
    }
    
    var message: String {
        switch self {
        case .denied: return "설정 -> Siri 및 검색 -> tree 에서 권한을 다시 켤 수 있습니다."
        case .restricted: return "Siri 사용이 불가능한 기기입니다."
        }
    }
}
