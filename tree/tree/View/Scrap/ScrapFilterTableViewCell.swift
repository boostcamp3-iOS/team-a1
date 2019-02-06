//
//  ScrapFilterTableViewCell.swift
//  tree
//
//  Created by Hyeontae on 06/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ScrapFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardBackgroudView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners(layer: cardBackgroudView.layer, radius: 15.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
