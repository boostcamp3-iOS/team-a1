//
//  ParametersEncoder.swift
//  tree
//
//  Created by ParkSungJoon on 25/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

enum ParameterEncodngTypes {
    case query
    case body
    case queryAndBody
}

extension ParameterEncodngTypes {
    func encode(request urlRequest: inout URLRequest, query: Parameters?, body: Parameters?) throws {
        do {
            switch self {
            case .query:
                guard let query = query else { return }
                urlRequest.url = urlRequest.url?.withQueries(query)
            case .body:
                guard let body = body else { return }
                try convertObjectToJSON(body, &urlRequest)
            case .queryAndBody:
                guard
                    let query = query,
                    let body = body
                    else { return }
                urlRequest.url = urlRequest.url?.withQueries(query)
                try convertObjectToJSON(body, &urlRequest)
            }
        } catch {
            throw error
        }
    }
    
    private func convertObjectToJSON(_ body: Parameters, _ urlRequest: inout URLRequest) throws {
        do {
            let encodedBody = try JSONSerialization.data(
                                    withJSONObject: body,
                                    options: .prettyPrinted
                                )
            urlRequest.httpBody = encodedBody
        } catch {
            throw NetworkError.convertToJSONFail
        }
    }
}
