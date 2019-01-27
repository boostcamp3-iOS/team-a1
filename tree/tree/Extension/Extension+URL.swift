//
//  Extension+URL.swift
//  tree
//
//  Created by ParkSungJoon on 25/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String: Any]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {
            URLQueryItem(
                name: $0.key,
                value: "\($0.value)"
                .addingPercentEncoding(
                withAllowedCharacters: .urlHostAllowed
            ))
        }
        return components?.url
    }
}
