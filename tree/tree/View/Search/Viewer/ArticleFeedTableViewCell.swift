//
//  ArticleFeedTableViewCell.swift
//  tree
//
//  Created by hyerikim on 26/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

class ArticleFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var betweenLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var articleOuterView: UIView!
    @IBOutlet weak var articleImageView: ArticleImage!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        roundConersSetup()
        settingShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func roundConersSetup() {
        articleOuterView.roundCorners(layer: articleOuterView.layer, radius: 10)
    }
    
    private func settingShadow() {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowRadius = 10.0
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    func settingData(article: Article) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.body
        self.dateLabel.text = article.date
        self.companyLabel.text = article.source.title
        betweenLabel.isHidden = true
        if article.author?.isEmpty == false {
            if let author = article.author?[0].name {
                betweenLabel.isHidden = false
                self.authorLabel.text = author
            }
        } 
        if let articleImage = article.image { 
            self.imageStackView.isHidden = false
            self.articleImageView.loadImageUrl(articleUrl: articleImage)
        } else {
            self.imageStackView.isHidden = true
        }
    }
    
    func settingData(scrappedArticle: ScrappedArticle) {
        self.titleLabel.text = scrappedArticle.articleTitle
        self.descriptionLabel.text = scrappedArticle.articleDescription
        self.dateLabel.text = scrappedArticle.articleDate
        self.companyLabel.text = scrappedArticle.company
        betweenLabel.isHidden = true
        if scrappedArticle.articleAuthor != nil {
            betweenLabel.isHidden = false
            self.authorLabel.text = scrappedArticle.articleAuthor
        }
        self.imageStackView.isHidden = true
        if let articleImage = scrappedArticle.image {
            self.imageStackView.isHidden = false
            self.articleImageView.image(from: articleImage as Data)
        }
    }
}
