//
//  TrendIntentCell.swift
//  TrendUI
//
//  Created by ParkSungJoon on 17/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class TrendIntentCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    
    func configure(by keyword: TrendingSearch, _ rank: Int) {
        rankLabel.text = "\(rank)"
        keywordLabel.text = keyword.title.query
    }
}
