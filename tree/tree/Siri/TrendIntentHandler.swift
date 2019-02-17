//
//  TrendIntentHandler.swift
//  tree
//
//  Created by ParkSungJoon on 17/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

final class TrendIntentHandler: NSObject, TrendIntentHandling {
    
    private let localizedLanguage = LocalizedLanguages.korean.rawValue
    
    func handle(intent: TrendIntent, completion: @escaping (TrendIntentResponse) -> Void) {
        guard
            let country = intent.country else {
            completion(TrendIntentResponse(code: .failure, userActivity: nil))
            return
        }
        APIManager.fetchDailyTrends(hl: localizedLanguage, geo: country) { (result) in
            switch result {
            case .success(let trendData):
                guard let recentDay = trendData.trend.searchesByDays.first else { return }
                guard let firstKeyword = recentDay.keywordList.first?.title.query else { return }
                completion(TrendIntentResponse.success(rank: 1 as NSNumber, keyword: firstKeyword))
            case .failure(let error):
                print(error.localizedDescription)
                completion(TrendIntentResponse(code: .failure, userActivity: nil))
            }
        }
    }
}
