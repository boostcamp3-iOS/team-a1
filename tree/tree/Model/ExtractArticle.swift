//
//  ExtractArticle.swift
//  tree
//
//  Created by hyeri kim on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

struct ExtractArticle: Codable {
    let title: String
    let body: String
    let image: String
    let keywords: [String]
    let description: String
    let category: Category
    let authors: Author?
    let source: Source
}
