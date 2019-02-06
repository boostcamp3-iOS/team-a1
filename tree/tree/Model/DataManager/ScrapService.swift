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
    
    func capitalFirstCharactor() -> String {
        let baseCategory: NSString = NSString(string: "\(self)")
        let firstCharactor = baseCategory.character(at: 0)
        guard let unicode = UnicodeScalar(firstCharactor - 32) as? UnicodeScalar else {
            return ""
        }
        let result = baseCategory.replacingCharacters(
            in: NSRange(location: 0, length: 1),
            with: String(Character(unicode))
        )
        return result
    }
}

