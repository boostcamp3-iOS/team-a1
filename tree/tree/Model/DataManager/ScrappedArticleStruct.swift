//
//  ScrappedArticleStruct.swift
//  tree
//
//  Created by Hyeontae on 21/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

public enum ScrappedArticleType: Int16,CaseIterable {
    case search = 0
    case webExtracted
    case web
    
    init(type: String) {
        for item in ScrappedArticleType.allCases {
            if type == item.stringValue {
                self = item
                return
            }
        }
        self = .search
    }
    
    var stringValue: String {
        return "\(self)"
    }
}

public protocol Scrappable { }

public struct SearchedArticleStruct: Scrappable {
    let articleData: Article
    let imageData: Data?
}

public struct WebExtractedArticleStruct: Scrappable {
    let title: String
    let detail: String
    let press: String
    let url: String
    let imageData: Data?
}

public struct WebViewArticleStruct: Scrappable {
    let title: String
    let press: String
    let url: String
    let webData: Data
}
