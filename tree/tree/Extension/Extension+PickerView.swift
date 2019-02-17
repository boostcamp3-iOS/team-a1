//
//  Extension+PickerView.swift
//  tree
//
//  Created by hyeri kim on 04/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {
    var tagNumber = 0 
    
    func pickerItemList() -> [String] {
        if tagNumber == 0 {
            return ArticleCategory.allCases.map { 
                $0.stringValue 
            }
        } else {
            return Languages.allCases.map { 
                $0.value 
            }
        }
    }
}
