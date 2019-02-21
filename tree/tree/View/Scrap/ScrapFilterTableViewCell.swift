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
    
    func setAllCategory(width: CGFloat) {
        setGradientLayer(.all, width: width)
        titleLabel.text = "All Category"
        descriptionLabel.text = "\(ScrapManager.countArticle(nil)) articles"
    }
    
    func configure(_ category: ArticleCategory, width: CGFloat) {
        setGradientLayer(category, width: width)
        setTitleLabel(category)
        setDescriptionLabel(category)
    }
    
    func setGradientLayer(_ category: ArticleCategory, width: CGFloat) {
        cardBackgroudView.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        //        gradientLayer.frame = cell.forGradientView.bounds
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: 120)
        gradientLayer.cornerRadius = 15.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = category.gradientColors
        forGradientView.layer.addSublayer(gradientLayer)
    }
    
    func setTitleLabel(_ category: ArticleCategory) {
        titleLabel.text = "\(category)".capitalized
    }
    
    func setDescriptionLabel(_ category: ArticleCategory) {
        let articleCount = ScrapManager.countArticle(category: category, nil)
        descriptionLabel.text = "\(articleCount) articles"
    }
}
