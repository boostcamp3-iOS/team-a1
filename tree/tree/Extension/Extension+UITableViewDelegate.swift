//
//  Extension+UITableViewDelegate.swift
//  tree
//
//  Created by Hyeontae on 14/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

enum CustomUIContextualActionState {
    case scrap
    case markAsRead
    case delete
}

extension UITableViewDelegate {
    func customUIContextualAction(
        _ type: CustomUIContextualActionState,
        _ articleData: Article?,
        _ imageData: Data?,
        completion: @escaping (Bool) -> Void
        ) -> UIContextualAction {
        switch type {
        case .scrap:
            guard let articleData = articleData else { return UIContextualAction() }
            var isScrapped: Bool = true
            var scrppaedArticle: ScrappedArticle?
            ScrapManager.articleIsScrapped(uri: articleData.uri) { (articleScrapped, article) in
                isScrapped = articleScrapped
                scrppaedArticle = article
            }
            let scrapAction = UIContextualAction(
                style: .normal,
                title: nil) { (_, _, success) in
                    if !isScrapped {
                        ScrapManager.scrapArticle(
                            article: articleData,
                            category: ArticleCategory(containString: "\(articleData.categories.first)"),
                            imageData: imageData
                        )
                    } else {
                        if let tempscrppaedArticle = scrppaedArticle {
                            ScrapManager.removeArticle(tempscrppaedArticle)
                        }
                    }
                    completion(true)
                    success(true)
            }
            if isScrapped {
                scrapAction.image = UIImage(named: "upload.png")
            } else {
                scrapAction.image = UIImage(named: "download.png")
            }
            scrapAction.backgroundColor = .blue
            return scrapAction
        case .delete:
            let deleteAction = UIContextualAction(
                style: .normal,
                title: nil) { (_, _, success) in
                    success(true)
                    completion(true)
            }
            deleteAction.image = UIImage(named: "garbage.png")
            deleteAction.backgroundColor = .red
            return deleteAction
        case .markAsRead:
            let readAction = UIContextualAction(
                style: .normal,
                title: nil) { (_, _, success) in
                    success(true)
                    completion(true)
            }
            readAction.image = UIImage(named: "checked.png")
            readAction.backgroundColor = .purple
            return readAction
        }
    }
}
