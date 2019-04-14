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
import NetworkFetcher

final class ScrapManager {
    static var managedContext: NSManagedObjectContext = {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else { return NSManagedObjectContext() }
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }()
    
    static func scrapArticle(
        _ type: ScrappedArticleType,
        articleStruct: Any
    ) {
        guard let entity =
            NSEntityDescription.entity(forEntityName: "ArticleBase", in: managedContext) else {
                return
        }
        let newArticleBase = ArticleBase(entity: entity, insertInto: managedContext)
        switch type {
        case .search:
            guard
                let articleStruct = articleStruct as? SearchedArticleStruct,
                let searchDescription =
                NSEntityDescription.entity(
                    forEntityName: articleStruct.entityName,
                    in: managedContext
                ) else { return }
            let detailEntity = Search(entity: searchDescription, insertInto: managedContext)
            newArticleBase.setArticle(articleStruct, detailEntity)
        case .webExtracted:
            guard
                let articleStruct = articleStruct as? WebExtractedArticleStruct,
                let webExtractedDescription = NSEntityDescription.entity(
                    forEntityName: articleStruct.entityName,
                    in: managedContext
                ) else { return }
            let detailEntity = WebExtracted(entity: webExtractedDescription, insertInto: managedContext)
            newArticleBase.setArticle(articleStruct, detailEntity)
        case .web:
            guard
                let articleStruct = articleStruct as? WebViewArticleStruct,
                let webDescription = NSEntityDescription.entity(
                    forEntityName: articleStruct.entityName,
                    in: managedContext
                ) else { return }
            let detailEntity = Web(entity: webDescription, insertInto: managedContext)
            newArticleBase.setArticle(articleStruct, detailEntity)
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func fetchArticles() -> [ArticleBase] {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        let sortDescriptor: NSSortDescriptor =
            NSSortDescriptor(
                key: #keyPath(ArticleBase.scrappedDate),
                ascending: false
        )
        request.sortDescriptors = [sortDescriptor]
        var result: [ArticleBase] = []
        result = fetchRequest(request)
        return result
    }
    
    static func fetchArticles(_ category: ArticleCategory) -> [ArticleBase] {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        var result: [ArticleBase] = []
        request.predicate =
            NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.articleType),
                category.rawValue
        )
        result = fetchRequest(request)
        return result
    }
    
    static func countArticle(_ isRead: Bool?) -> Int {
        if let isRead = isRead {
            return countArticleFetch(NSPredicate(format: "isRead == %@", NSNumber(value: isRead)))
        }
        return countArticleFetch(nil)
    }
    
    static func countArticle(category: ArticleCategory, _ isRead: Bool?) -> Int {
        var predicate: NSPredicate
        if let isRead = isRead {
            predicate = NSPredicate(
                format: "isRead == %@ AND %K == %@",
                NSNumber(value: isRead),
                #keyPath(ArticleBase.category),
                NSNumber(value: category.rawValue)
            )
        } else {
            predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.category),
                NSNumber(value: category.rawValue)
            )
        }
        return countArticleFetch(predicate)
    }
    
    typealias IsScrappedHandler = (Bool, ArticleBase?) -> Void
    
    static func articleIsScrapped(
        _ articleType: ScrappedArticleType,
        identifier articleIdentifier: String,
        completion: @escaping IsScrappedHandler
    ) -> Void {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        switch articleType {
        case .web:
            request.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.web.webURL),
                articleIdentifier)
        case .webExtracted:
            request.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.webExtracted.webURL),
                articleIdentifier)
        case .search:
            request.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.searched.webURI),
                articleIdentifier)
        }
        do {
            let result = try managedContext.fetch(request)
            if result.isEmpty {
                completion(false, nil)
            } else {
                completion(true, result.first)
            }
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    static func readArticle(
        _ articleType: ScrappedArticleType,
        _ articleIdentifier: String
    ) {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        switch articleType {
        case .search:
            request.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.searched.webURI),
                articleIdentifier)
        case .web:
            request.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.web.webURL),
                articleIdentifier)
        case .webExtracted:
            request.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(ArticleBase.webExtracted.webURL),
                articleIdentifier)
        }
        do {
            let result = try managedContext.fetch(request)
            result.first?.isRead = true
            try managedContext.save()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.scrapViewController?.setupScrapBadgeValue()
        } catch {
            print("Could not fetch. \(error)")
        }
        
    }
    
    static func countArticleFetch(_ predicate: NSPredicate?) -> Int{
        let request: NSFetchRequest = NSFetchRequest<NSNumber>(entityName: "ArticleBase")
        request.resultType = .countResultType
        if let predicate = predicate {
            request.predicate = predicate
        }
        do {
            let result = try managedContext.fetch(request)
            guard let resultCount = result.first?.intValue else {
                return 0
            }
            return resultCount
        } catch {
            print("Could not fetch. \(error)")
        }
        return 0
    }
    
    static func removeArticle(_ article: ArticleBase) {
        managedContext.delete(article)
        switch article.articleTypeEnum {
        case .web:
            if let articleDetail = article.web {
                managedContext.delete(articleDetail)
            }
        case .webExtracted:
            if let articleDetail = article.webExtracted {
                managedContext.delete(articleDetail)
            }
        case .search:
            if let articleDetail = article.searched {
                managedContext.delete(articleDetail)
            }
        }
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func removeAllScrappedArticle() {
        let request: NSFetchRequest = ArticleBase.fetchRequest()
        do {
            let results = try managedContext.fetch(request)
            for item in results {
                    removeArticle(item)
            }
            try managedContext.save()
        } catch {
            print("Could not delete. \(error)")
        }
        print("all data is Removed")
    }
    
    static func fetchRequest(_ request: NSFetchRequest<ArticleBase>) -> [ArticleBase] {
        var result: [ArticleBase] = []
        do {
            result = try managedContext.fetch(request)
        } catch {
            print("Could not fetch. \(error)")
        }
        return result
    }
    
    static func markAllAsRead() {
        let batchUpdate = NSBatchUpdateRequest(entityName: "ArticleBase")
        batchUpdate.propertiesToUpdate = [#keyPath(ArticleBase.isRead): true]
        batchUpdate.affectedStores = managedContext.persistentStoreCoordinator?.persistentStores
        batchUpdate.resultType = .updatedObjectsCountResultType
        do {
            try managedContext.execute(batchUpdate)
        } catch {
            print("Could not update \(error)")
        }
    }
}

private extension NSManagedObject {
    func setCategory(_ category: ArticleCategory) {
        self.setValue(category.rawValue, forKey: #keyPath(ArticleBase.category))
    }
    
    func setupBaseProperty(_ type: ScrappedArticleType) {
        self.setValue(type.rawValue, forKey: #keyPath(ArticleBase.articleType))
        self.setValue(NSDate(), forKey: #keyPath(ArticleBase.scrappedDate))
        self.setValue(false, forKey: #keyPath(ArticleBase.isRead))
    }
    
    func setArticle(_ baseStruct: Scrappable, _ detailEntity: NSManagedObject) {
        switch baseStruct {
        case is WebViewArticleStruct:
            guard
                let webViewStruct = baseStruct as? WebViewArticleStruct,
                let detailEntity = detailEntity as? Web
                else { return }
            self.setupBaseProperty(.web)
            self.setCategory(.live)
            self.setValue(webViewStruct.title, forKey: #keyPath(ArticleBase.title))
            self.setValue(webViewStruct.press, forKey: #keyPath(ArticleBase.author))
            detailEntity.webData = webViewStruct.webData as NSData
            detailEntity.webURL = webViewStruct.url
            self.setValue(detailEntity, forKey: #keyPath(ArticleBase.web))
        case is WebExtractedArticleStruct:
            guard
                let webExtractedStruct = baseStruct as? WebExtractedArticleStruct,
                let detailEntity = detailEntity as? WebExtracted
                else { return }
            self.setupBaseProperty(.webExtracted)
            self.setCategory(.live)
            self.setValue(webExtractedStruct.title, forKey: #keyPath(ArticleBase.title))
            self.setValue(webExtractedStruct.press, forKey: #keyPath(ArticleBase.author))
            detailEntity.contents = webExtractedStruct.detail
            detailEntity.webURL = webExtractedStruct.url
            if let imageData = webExtractedStruct.imageData {
                 detailEntity.imageData = imageData as NSData
            }
            self.setValue(detailEntity, forKey: #keyPath(ArticleBase.webExtracted))
        case is SearchedArticleStruct:
            self.setupBaseProperty(.search)
            guard
                let searhedArticleStruct = baseStruct as? SearchedArticleStruct,
                let articleData = searhedArticleStruct.articleData as? Article,
                let detailEntity = detailEntity as? Search
                else { return }
            if articleData.author?.isEmpty == false {
                if let author = articleData.author?[0].name {
                    self.setValue(author, forKey: #keyPath(ArticleBase.author))
                }
            }
            self.setCategory(ArticleCategory(containString: "\(articleData.categories.first)"))
            self.setValue(articleData.title, forKey: #keyPath(ArticleBase.title))
            detailEntity.articleDate = articleData.date
            detailEntity.webURI = articleData.uri
            detailEntity.contents = articleData.body
            detailEntity.company = articleData.source.title
            if let imageData: Data = searhedArticleStruct.imageData {
                detailEntity.imageData = imageData as NSData
            }
            self.setValue(detailEntity, forKey: #keyPath(ArticleBase.searched))
        default:
            fatalError("Check ArticleDataStruct Type")
        }
    }
}
