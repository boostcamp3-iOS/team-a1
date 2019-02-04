//
//  Enum+Countries.swift
//  tree
//
//  Created by ParkSungJoon on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

enum Country: Int {
    case usa = 0
    case kor = 1
    case jpn = 2
    case fra = 3
    case rus = 4
    case uk = 5
    case ita = 6
    case ger = 7
    
    var info: (name: String, code: String) {
        switch self {
        case .usa: return ("미국", "US")
        case .kor: return ("대한민국", "KR")
        case .jpn: return ("일본", "JP")
        case .fra: return ("프랑스", "FR")
        case .rus: return ("러시아", "RU")
        case .uk: return ("영국", "GB")
        case .ita: return ("이탈리아", "IT")
        case .ger: return ("독일", "DE")
        }
    }
}
