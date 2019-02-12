//
//  LiveFeedTableViewCell.swift
//  tree
//
//  Created by hyeri kim on 09/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class EventFeedCell: UITableViewCell {

    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var articleCountLabel: UILabel!
    
    private var shadowView: UIView {
        let shadowView = UIView(
            frame: CGRect(
                x: innerMargin,
                y: innerMargin,
                width: bounds.width - (2 * innerMargin),
                height: bounds.height - (2 * innerMargin))
        )
        insertSubview(shadowView, at: 0)
        return shadowView
    }
    private let innerMargin: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners(layer: backgroundContainerView.layer, radius: 14)
        self.applyShadow(
            shadowView: shadowView,
            width: CGFloat(0.0),
            height: CGFloat(0.0)
        )
    }
}
