//
//  Enum+Languages.swift
//  tree
//
//  Created by hyeri kim on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum Languages: CaseIterable {
    case eng
    case jpn
    case fra
    case ita
    case spa
    case rus
    case deu
    
    var value: String {
        switch self {
        case .eng: return "English"
        case .jpn: return "Japanese"
        case .fra: return "France"
        case .ita: return "Italian"
        case .spa: return "spanish"
        case .rus: return "Russian"
        case .deu: return "Dutch"
        }
    }
}
