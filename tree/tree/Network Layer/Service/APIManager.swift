//
//  APIManager.swift
//  tree
//
//  Created by ParkSungJoon on 25/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

final class APIManager {
    static func getArticles(
        keyword: String,
        keywordLoc: String,
        lang: String,
        articlesSortBy: String,
        articlesPage: Int,
        completion: @escaping (Result<Articles>
    ) -> Void ) {
        APICenter<EventRegistryAPI>().request(.getArticles(
                keyword: keyword,
                keywordLoc: keywordLoc,
                lang: lang,
                articlesSortBy: articlesSortBy,
                articlesPage: articlesPage)) { (data, response, error) in
                    guard error == nil else {
                        return completion(Result.failure(error!))
                    }
                    guard let responseData = data else { return }
                    do {
                        let decodeJSON = try JSONDecoder().decode(Articles.self, from: responseData)
                        completion(Result.success(decodeJSON))
                    } catch {
                        completion(Result.failure(NetworkError.decodingFail))
                    }
                }
    }
}
