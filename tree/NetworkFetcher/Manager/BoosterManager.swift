//
//  APIManager.swift
//  tree
//
//  Created by ParkSungJoon on 25/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation
import Booster

public final class BoosterManager {
    
    public static func fetchDefaultArticles(
        keyword: String,
        keywordLoc: String,
        lang: String,
        articlesSortBy: String,
        articlesPage: Int,
        completion: @escaping (Result<Articles>) -> Void ) -> URLSessionDataTask {
        return BoosterCenter<EventRegistryAPI>().request(.fetchDefaultArticles(
        keyword: keyword,
        keywordLoc: keywordLoc,
        lang: lang,
        articlesSortBy: articlesSortBy,
        articlesPage: articlesPage)) { (data, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let responseData = data else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(Articles.self, from: responseData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(BoosterError.decodingFail))
            }
        }
    }
    
    public static func fetchArticles(
        keyword: String,
        keywordLoc: String,
        lang: String,
        articlesSortBy: String,
        categoryUri: String,
        articlesPage: Int,
        completion: @escaping (Result<Articles>) -> Void ) -> URLSessionDataTask {
        return BoosterCenter<EventRegistryAPI>().request(.fetchArticles(
                keyword: keyword,
                keywordLoc: keywordLoc,
                lang: lang,
                articlesSortBy: articlesSortBy,
                categoryUri: categoryUri,
                articlesPage: articlesPage)) { (data, error) in
                    guard error == nil else {
                        return completion(Result.failure(error!))
                    }
                    guard let responseData = data else { return }
                    do {
                        let decodeJSON = try JSONDecoder().decode(Articles.self, from: responseData)
                        completion(Result.success(decodeJSON))
                    } catch {
                        completion(Result.failure(BoosterError.decodingFail))
                    }
            }
    }
    
    public static func fetchDailyTrends(
        hl: String,
        geo: String,
        completion: @escaping (Result<TrendDays>) -> Void) {
        BoosterCenter<GoogleTrendAPI>().requestDownload(.fetchDailyTrends(hl: hl, geo: geo)) { (rawJSON, error)  in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let rawJSON = rawJSON else { return }
            guard let prettyJSON = rawJSON.components(separatedBy: "\n").last else { return }
            guard let jsonData = prettyJSON.data(using: .utf8) else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(TrendDays.self, from: jsonData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(BoosterError.decodingFail))
            }
        }
    }
    
    public static func requestGraphData(
        startDate: String,
        endDate: String,
        timeUnit: String,
        keywordGroups: [[String: Any]],
        completion: @escaping (Result<Graph>) -> Void) {
        BoosterCenter<NaverAPIMode>().request(.fetchKeywordGraphData(
            startDate: startDate,
            endDate: endDate,
            timeUnit: timeUnit,
            keywordGroups: keywordGroups
        )) { (data, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let responseData = data else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(Graph.self, from: responseData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(BoosterError.decodingFail))
            }
        }
    }
    
    public static func fetchRecentEvents(
        completion: @escaping (Result<Events>) -> Void) {
        BoosterCenter<EventRegistryAPI>().request(.fetchRecentEvents) { (data, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let responseData = data else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(Events.self, from: responseData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(BoosterError.decodingFail))
            }
        }
    }
    
    public static func extractArticle(
        url: String,
        completion: @escaping (Result<ExtractArticle>) -> Void) {
        BoosterCenter<ExtractAPI>().request(.extractArticleInfo(
            url: url
        )) { (data, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let responseData = data else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(ExtractArticle.self, from: responseData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(BoosterError.decodingFail))
            }
        }
    }
}
