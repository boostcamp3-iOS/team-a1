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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
