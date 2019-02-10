//
//  LiveFeedTableViewCell.swift
//  tree
//
//  Created by hyeri kim on 09/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class LiveFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var articleCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
