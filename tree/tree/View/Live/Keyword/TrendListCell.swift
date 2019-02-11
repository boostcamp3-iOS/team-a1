//
//  TrandTableViewCell.swift
//  tree
//
//  Created by ParkSungJoon on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class TrendListCell: UITableViewCell, HTMLDecodable {
    
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subscriptLabel: UILabel!
    
    private weak var shadowView: UIView?
    private let innerMargin: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContainerView.layer.cornerRadius = 14
        configureShadow()
    }
    
    func configure(by content: Default, with section: Int, _ row: Int) {
        titleLabel.text = content.searchesByDays[section].keywordList[row].title.query
        rankLabel.text = "\(row + 1)"
        guard
            let article = content.searchesByDays[section]
                          .keywordList[row]
                          .articles.first else { return }
        subscriptLabel.text = decode(article.title)
        hitsLabel.text = content.searchesByDays[section].keywordList[row].formattedTraffic
    }
    
    private func configureShadow() {
        let shadowView = UIView(frame: CGRect(x: innerMargin,
                                              y: innerMargin,
                                              width: bounds.width - (2 * innerMargin),
                                              height: bounds.height - (2 * innerMargin)
        ))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        applyShadow(
            shadowView: shadowView,
            width: CGFloat(0.0),
            height: CGFloat(0.0)
        )
    }
}
