//
//  Extension+UITableViewDelegate.swift
//  tree
//
//  Created by Hyeontae on 14/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

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
        _ articleUri: String?,
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
                            .nativeSearch ,
                            articleStruct:
                            NativeSearchedArticleStruct(articleData: articleData, imageData: imageData)
                        )
//                        ScrapManager.scrapArticle(
//                            article: articleData,
//                            imageData: imageData
//                        )
                    } else {
                        if let tempscrppaedArticle = scrppaedArticle {
                            ScrapManager.removeArticle(tempscrppaedArticle)
                        }
                    }
                    guard
                        let appDelegate =
                            UIApplication.shared.delegate as? AppDelegate,
                        let scrapViewController =
                            appDelegate.scrapViewController as? ScrapViewController
                        else { return }
                    
                    scrapViewController.scrappedArticles = ScrapManager.fetchArticles()
                    scrapViewController.setupScrapBadgeValue()
                    completion(true)
                    success(true)
            }
            if isScrapped {
                scrapAction.image = UIImage(named: "upload.png")
                scrapAction.backgroundColor = .red
            } else {
                scrapAction.image = UIImage(named: "download.png")
                scrapAction.backgroundColor = .blue
            }
            
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
                    if let articleUri = articleUri {
                        ScrapManager.readArticle(articleUri)
                        completion(true)
                    } else {
                        completion(false)
                    }
                    success(true)
            }
            readAction.image = UIImage(named: "checked.png")
            readAction.backgroundColor = .purple
            return readAction
        }
    }
}
