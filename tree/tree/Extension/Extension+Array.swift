//
//  Extension+Array.swift
//  tree
//
//  Created by Hyeontae on 20/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}
