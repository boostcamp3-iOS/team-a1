//
//  Extension+PickerView.swift
//  tree
//
//  Created by hyeri kim on 04/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {
    var pickerType: PickerViewType = .language
    var tagNumber = 0 {
        didSet {
            if tagNumber == 0 {
                pickerType = .category
            } else {
                pickerType = .language
            }
        }
    }
    
    func pickerItemList() -> [String] {
        switch pickerType {
        case .language:
            return Languages.allCases.map { 
                $0.value 
            }
        case .category:
            return ArticleCategory.allCases.map { 
                $0.stringValue 
            }
        }
    }
    
    func extractUserSelectedLanguage(selectedItem: String) -> String? {
        let userSelectedItem = Languages.allCases.filter {$0.value == selectedItem}.map {"\($0)"}
        return userSelectedItem.joined()
    }
    
    func extractUserSelectedLan(selectedLabel: String) -> String? {
        let userSelectedLabel = Languages.allCases.filter {"\($0)" == selectedLabel}.map {"\($0.value)"}
        return userSelectedLabel.joined()
    }
    
    func findRow(userValue: String) -> Int {
        var index = 0 
        switch pickerType {
        case .category:
            ArticleCategory.allCases.forEach({
                if $0.stringValue == userValue {
                    index = $0.rawValue
                }
            })
            return index
        case .language:
            Languages.allCases.forEach({
                if $0.value == userValue {
                    index = $0.rawValue
                }
            })
            return index
        }
    }
}
