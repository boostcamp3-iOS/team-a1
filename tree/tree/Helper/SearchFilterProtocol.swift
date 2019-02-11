//
//  SearchFilterProtocol.swift
//  tree
//
//  Created by hyeri kim on 05/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

protocol FilterSettingDelegate: class {
    func observeUserSetting(keyword: String, sort: String, category: String, language: String)
}
