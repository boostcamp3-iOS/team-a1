//
//  RankKeywordCell.swift
//  Widget
//
//  Created by ParkSungJoon on 23/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

class RankKeywordCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    
    func configure(by keyword: TrendingSearch, _ rank: Int) {
        rankLabel.text = "\(rank)"
        keywordLabel.text = keyword.title.query
    }
}
