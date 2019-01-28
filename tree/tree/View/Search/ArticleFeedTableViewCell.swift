//
//  ArticleFeedTableViewCell.swift
//  tree
//
//  Created by hyerikim on 26/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var articleOuterView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingArticleOuterView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func settingData(article: Article ) {
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.body
        self.dateLabel.text = article.date
        self.companyLabel.text = article.source.title
        
        DispatchQueue.global().async {
            if let articleImage = article.image {
                guard let imageURL = URL(string: articleImage) else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                
                DispatchQueue.main.async {
                    self.articleImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private func settingArticleOuterView() {
        articleOuterView.layer.cornerRadius = 10
    }
}
