//
//  Extension+PickerView.swift
//  tree
//
//  Created by hyeri kim on 04/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {
    private let categories = ["Arts","Businees","Computers","Games","Health","Home", "Recreation","Reference","Regional","Science","Shopping","Society","Sports"]
    private let languages = ["Any","Eng","Jpn","Fra","Ita","Spa","Rus","Deu"]
    var tagNumber = 0 
    
    func getList() -> [String] {
        if tagNumber == 0 {
            return categories
        } else {
            return languages
        }
    }
}
