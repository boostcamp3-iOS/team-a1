//
//  ScrappedArticleStruct.swift
//  tree
//
//  Created by Hyeontae on 21/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

public enum ScrappedArticleType: CaseIterable {
    case search
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

public struct NativeSearchedArticleStruct {
    let articleData: Article
    let imageData: Data?
}

public struct WebExtractedArticleStruct {
    let title: String
    let detail: String
    let press: String
    let url: String
    let imageData: Data?
}

public struct WebViewArticleStruct {
    let title: String
    let press: String
    let url: String
    let webData: Data
}
