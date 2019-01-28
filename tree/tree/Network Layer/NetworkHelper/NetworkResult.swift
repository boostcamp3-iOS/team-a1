//
//  NetworkResult.swift
//  tree
//
//  Created by ParkSungJoon on 26/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(NetworkError)
    
    var value: Value? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    var error: NetworkError? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}
