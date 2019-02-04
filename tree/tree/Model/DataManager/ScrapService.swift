//
//  ScrapService.swift
//  tree
//
//  Created by Hyeontae on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum ScrappedArticleProperty {
    case articleAuthor
    case articleDescription
    case company
    case articleDate
    case image
    case isRead
    case language
    case scrappedDate
    case articleTitle
    case articleUri
    case category
    
    func toString() -> String {
        return "\(self)"
    }
}

enum ArticleCategory {
    // MARK: Check Arts
    case arts
    case business
    case computers
    case games
    case health
    case home
    case recreation
    case reference
    case regional
    case science
    case shopping
    case society
    case sports

    func toString() -> String {
        return "\(self)"
    }
}

