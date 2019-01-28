//
//  NetworkResponse.swift
//  tree
//
//  Created by ParkSungJoon on 26/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum ResponseTypes {
    case success
    case clientError
    case serverError
    case failure
}

struct NetworkResponse {
    func result(_ response: HTTPURLResponse) -> ResponseTypes {
        switch response.statusCode {
        case 200..<300: return .success
        case 400..<500: return .clientError
        case 500..<600: return .serverError
        default: return .failure
        }
    }
}
