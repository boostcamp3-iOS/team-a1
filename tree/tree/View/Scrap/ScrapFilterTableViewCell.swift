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
    @IBOutlet weak var forGradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCorners(layer: cardBackgroudView.layer, radius: 15.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setGradientLayer(_ category: ArticleCategory, width: CGFloat) {
        var gradientLayer = CAGradientLayer()
        //        gradientLayer.frame = cell.forGradientView.bounds
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: 120)
        gradientLayer.cornerRadius = 15.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = category.gradientColors()
        forGradientView.layer.addSublayer(gradientLayer)
    }
}
