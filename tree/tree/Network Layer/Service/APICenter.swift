//
//  APICenter.swift
//  tree
//
//  Created by ParkSungJoon on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

class APICenter<Service: APIService> {
    func request(
        _ service: Service,
        completion: @escaping (
                    _ data: Data?,
                    _ response: URLResponse?,
                    _ error: Error?
    ) -> Void) {
        do {
            let urlRequest = try makeURLRequest(from: service)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    return completion(nil, nil, error)
                }
                guard let data = data else {
                    return completion(nil, nil, NetworkError.noData)
                }
                guard let response = response as? HTTPURLResponse else {
                    return completion(nil, nil, NetworkError.noResponse)
                }
                switch NetworkResponse().result(response) {
                case .success:
                    completion(data, response, error)
                case .failure:
                    completion(nil, nil, error)
                case .clientError:
                    completion(nil, nil, NetworkError.clientError)
                case .serverError:
                    completion(nil, nil, NetworkError.serverError)
                }
            }
            task.resume()
        } catch {
            completion(nil, nil, NetworkError.makeBuildRequestFail)
        }
    }
    
    private func makeURLRequest(from service: Service) throws -> URLRequest {
        let fullUrl = service.baseURL.appendingPathComponent(service.path)
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = service.method.rawValue
        switch service.task {
        case .request:
            setHeaderField(&urlRequest)
        case .requestWith(let query, let body, let encoder):
            do {
                try encoder.encode(request: &urlRequest, query: query, body: body)
                setHeaderField(&urlRequest)
            } catch {
                throw error
            }
        }
        return urlRequest
    }
    
    private func setHeaderField(_ urlRequest: inout URLRequest) {
        urlRequest.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue
        )
        urlRequest.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue
        )
    }
}
