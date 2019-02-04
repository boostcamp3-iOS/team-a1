//
//  ScrapManager.swift
//  tree
//
//  Created by Hyeontae on 03/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class ScrapManager {

    // completion으로 처리를 할 때 -> Void 를 해줘야 한다?
    static func scrapArticle(
        article: Article,
        category: ArticleCategory,
        imageData: Data?
    ) -> Void {
        var managedContext: NSManagedObjectContext {
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return NSManagedObjectContext()
            }
            let managedContext: NSManagedObjectContext =
                appDelegate.persistentContainer.viewContext

            return managedContext
        }
        guard let entity =
            NSEntityDescription.entity(forEntityName: "ScrappedArticle", in: managedContext) else {
                return
        }
        let newArticle = ScrappedArticle(entity: entity, insertInto: managedContext)
        newArticle.setValues(
            newArticle,
            articleData: article,
            categoryEnum: category,
            imageData: imageData
        )
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

private extension NSManagedObject {
    func setValue(_ value: Any?, forKey property: ScrappedArticleProperty) {
        self.setValue(value, forKeyPath: "\(property)")
    }
    func setCategory(_ category: ArticleCategory) {
        self.setValue(category.toString(), forKey: .category)
    }
    // MARK: string format for date
    func setValues(
        _ newArticle: ScrappedArticle,
        articleData: Article,
        categoryEnum: ArticleCategory,
        imageData: Data?
    ) {
        if let imageData: Data = imageData {
            newArticle.setValue(imageData, forKey: .image)
        }
        newArticle.setCategory(categoryEnum)
        newArticle.setValue(articleData.lang, forKey: .language)
        newArticle.setValue(articleData.author?[0] ?? "", forKey: .articleAuthor)
        newArticle.setValue(articleData.date, forKey: .articleDate)
        newArticle.setValue(articleData.title, forKey: .articleTitle)
        newArticle.setValue(NSDate(), forKey: .scrappedDate)
        newArticle.setValue(false, forKey: .isRead)
        newArticle.setValue(articleData.uri, forKey: .articleUri)
        newArticle.setValue(articleData.source.title, forKey: .company)
        newArticle.setValue(articleData.body, forKey: .articleDescription)
        
    }
}
