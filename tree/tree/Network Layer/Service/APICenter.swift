//
//  APICenter.swift
//  tree
//
//  Created by ParkSungJoon on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

typealias HTTPHeader = [HTTPHeaderField: String]

class APICenter<Service: APIService> {
    func request(
        _ service: Service,
        completion: @escaping (
                    _ data: Data?,
                    _ error: NetworkError?
    ) -> Void) {
        do {
            let urlRequest = try makeURLRequest(from: service)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, _) in
                guard let data = data else {
                    return completion(nil, NetworkError.noData)
                }
                guard let response = response as? HTTPURLResponse else {
                    return completion(data, NetworkError.noResponse)
                }
                let statusCode = response.statusCode
                switch NetworkResponse().result(response) {
                case .success:
                    completion(data, nil)
                case .failure:
                    completion(data, NetworkError.networkFail)
                case .clientError:
                    completion(data, NetworkError.clientError(statusCode: statusCode))
                case .serverError:
                    completion(data, NetworkError.serverError(statusCode: statusCode))
                }
            }
            task.resume()
        } catch {
            completion(nil, NetworkError.makeURLRequestFail)
        }
    }
    
    func requestDownload(
        _ service: Service,
        completion: @escaping (
        _ pureJSON: String?,
        _ error: NetworkError?
        ) -> Void) {
        do {
            let urlRequest = try makeURLRequest(from: service)
            let task = URLSession.shared.downloadTask(with: urlRequest) { (localURL, response, _) in
                guard let localURL = localURL else {
                    return completion(nil, NetworkError.invalidURL)
                }
                do {
                    let rawJSON = try String(contentsOf: localURL)
                    guard let pureJSON = rawJSON.components(separatedBy: "\n").last else { return }
                    guard let response = response as? HTTPURLResponse else {
                        return completion(pureJSON, NetworkError.noResponse)
                    }
                    let statusCode = response.statusCode
                    switch NetworkResponse().result(response) {
                    case .success:
                        completion(pureJSON, nil)
                    case .failure:
                        completion(pureJSON, NetworkError.networkFail)
                    case .clientError:
                        completion(pureJSON, NetworkError.clientError(statusCode: statusCode))
                    case .serverError:
                        completion(pureJSON, NetworkError.serverError(statusCode: statusCode))
                    }
                } catch {
                    completion(nil, NetworkError.decodingFail)
                }
            }
            task.resume()
        } catch {
            completion(nil, NetworkError.makeURLRequestFail)
        }
    }
    
    private func makeURLRequest(from service: Service) throws -> URLRequest {
        var fullUrl = service.baseURL
        if let path = service.path {
            fullUrl = fullUrl.appendingPathComponent(path)
        }
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = service.method.rawValue
        switch service.task {
        case .request:
            setHeaderField(&urlRequest, header: service.header)
        case .requestWith(let query, let body, let encoder):
            do {
                try encoder.encode(request: &urlRequest, query: query, body: body)
                setHeaderField(&urlRequest, header: service.header)
            } catch {
                throw error
            }
        }
        return urlRequest
    }
    
    private func setHeaderField(_ urlRequest: inout URLRequest, header: HTTPHeader?) {
        urlRequest.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue
        )
        urlRequest.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue
        )
        guard let header = header else { return }
        for (key, value) in header {
            urlRequest.setValue(value, forHTTPHeaderField: key.rawValue)
        }
    }
}
