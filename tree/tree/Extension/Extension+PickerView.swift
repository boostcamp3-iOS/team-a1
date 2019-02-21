//
//  Extension+PickerView.swift
//  tree
//
//  Created by hyeri kim on 04/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {
    var pickerType: PickerViewType = .category
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
    
    // 사용자가 선택한 언어 추출
    func extractUserSelectedLanguage(selectedItem: String) -> String? {
        let userSelectedItem = Languages.allCases.filter {"\($0)" == selectedItem}.map {$0.value}
        return userSelectedItem.joined()
    }
    
    // 사용자가 선택한 언어 축약형 추출
    func extractUserSelectedLan(selectedRowLabel: String) -> String? {
        let userSelectedLabel = Languages.allCases.filter {$0.value == selectedRowLabel}.map {"\($0)"}
        return userSelectedLabel.joined()
    }
    
    func findSelectedRow(rowValue: String) -> Int {
        var index = 0 
        switch pickerType {
        case .category:
            ArticleCategory.allCases.forEach({
                if $0.stringValue == rowValue {
                    index = $0.rawValue
                }
            })
            return index
        case .language:
            Languages.allCases.forEach({
                if $0.value == rowValue {
                    index = $0.rawValue
                }
            })
            return index
        }
    }
}
