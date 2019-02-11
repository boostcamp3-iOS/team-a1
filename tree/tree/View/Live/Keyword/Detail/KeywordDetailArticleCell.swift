//
//  KeywordDetailArticleCell.swift
//  tree
//
//  Created by ParkSungJoon on 10/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class KeywordDetailArticleCell: UITableViewCell, HTMLDecodable {

    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pressLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    private weak var shadowView: UIView?
    private let innerMargin: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners(layer: backgroundContainerView.layer, radius: 14)
        configureShadow()
    }
    
    func configure(_ article: KeywordArticles) {
        guard
            let title = decode(article.title),
            let press = decode(article.source) else {
                return
        }
        titleLabel.text = title
        pressLabel.text = press
        timeAgoLabel.text = article.timeAgo
    }
    
    private func configureShadow() {
        let shadowView = UIView(
            frame: CGRect(
                x: innerMargin,
                y: innerMargin,
                width: bounds.width - (2 * innerMargin),
                height: bounds.height - (2 * innerMargin))
        )
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        self.applyShadow(
            shadowView: shadowView,
            width: CGFloat(0.0),
            height: CGFloat(0.0)
        )
    }
}
