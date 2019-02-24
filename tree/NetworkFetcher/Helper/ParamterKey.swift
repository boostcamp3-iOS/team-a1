//
//  ParamterKey.swift
//  NetworkFetcher
//
//  Created by hyeri kim on 24/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum ParamterKey {
    case keyword
    case keywordLoc
    case lang
    case articlesSortBy
    case articlesPage
    case categoryUri
    case action
    case resultType
    case articlesCount
    case includeArticleImage
    case includeArticleCategories
    case articleBodyLen
    case apiKey
    
    var stringValue: String {
        return "\(self)"
    } 
}
