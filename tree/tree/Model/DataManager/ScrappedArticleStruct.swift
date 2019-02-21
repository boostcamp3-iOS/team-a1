//
//  ScrappedArticleStruct.swift
//  tree
//
//  Created by Hyeontae on 21/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

public enum ScrappedArticleTypeEnum {
    case nativeSearch
    case nativeWeb
    case web
    
    var stringValue: String {
        return "\(self)"
    }
}

public struct NativeSearchedArticleStruct {
    let articleData: Article
    let imageData: Data?
}

public struct WebNativeViewrArticleStruct {
    let title: String
    let press: String
}

public struct WebViewArticleStruct {
    let title: String
    let press: String
    let url: URL
    let webData: Data
}
