//
//  ScrapViewController.swift
//  tree
//
//  Created by Hyeontae on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import CoreData

class ScrapViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton! {
        didSet {
            filterButton.addTarget(
                self,
                action: #selector(filterButtonDidTap),
                for: .touchUpInside
            )
        }
    }
    @IBOutlet weak var readAllButton: UIButton! {
        didSet {
            readAllButton.addTarget(
                self,
                action: #selector(readAllButtonDidTap),
                for: .touchUpInside
            )
        }
    }
    @IBOutlet weak var placeholderLabel: UILabel!
    
    private let articleFeedCellIdentifier = "ScrapTableViewCell"
    private let liveCellIdentifier = "KeywordDetailArticleCell"
    private lazy var resultController: NSFetchedResultsController<ArticleBase> = {
        let fetchRequest = NSFetchRequest<ArticleBase>(entityName: "ArticleBase")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "scrappedDate", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: ScrapManager.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResult()
        setupTableView()
        registerArticleCell()
        setupScrapBadgeValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScrapBadgeValue()
    }
    
    private func updateResult() {
        do {
           try resultController.performFetch()
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        resultController.delegate = self
    }
    
    private func registerArticleCell() {
        let articleFeedNib = UINib(nibName: "ArticleFeedTableViewCell", bundle: nil)
        tableView.register(articleFeedNib, forCellReuseIdentifier: articleFeedCellIdentifier)
        let articleNib = UINib(nibName: liveCellIdentifier, bundle: nil)
        tableView.register(articleNib, forCellReuseIdentifier: liveCellIdentifier)
    }
    
    @objc func filterButtonDidTap(_ sender: UIButton) {
        guard let scrapFilterViewController =
            UIStoryboard.init(name: "ScrapFilter", bundle: nil)
                .instantiateViewController(withIdentifier: "ScrapFilterViewController")
                as? ScrapFilterViewController else { return }
        scrapFilterViewController.filterDelegate = self
        present(scrapFilterViewController, animated: true)
    }
    
    @objc func readAllButtonDidTap(_ sender: UIButton) {
        ScrapManager.markAllAsRead()
        setupScrapBadgeValue()
    }
}

extension ScrapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = resultController.sections?[0] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let scrappedArticle = resultController.object(at: indexPath)
        switch scrappedArticle.articleTypeEnum {
        case .search:
            guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: articleFeedCellIdentifier,
                    for: indexPath
                    ) as? ArticleFeedTableViewCell else {
                        fatalError(FatalError.invalidCell.localizedDescription)
            }
            cell.setupData(scrappedArticle: scrappedArticle)
            return cell
        case .webExtracted:
            fallthrough
        case .web:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: liveCellIdentifier, for: indexPath)
                as? KeywordDetailArticleCell else {
                    fatalError(FatalError.invalidCell.localizedDescription)
            }
            cell.configure(scrappedArticle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scrappedArticle: ArticleBase = resultController.object(at: indexPath)
        let articleType = scrappedArticle.articleTypeEnum
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        switch articleType {
        case .search:
            fallthrough
        case .webExtracted:
            guard
                let articleView = storyboard.instantiateViewController(
                    withIdentifier: "ArticleDetailViewController"
                    ) as? ArticleDetailViewController else { return }
            articleView.scrappedArticleDetail = scrappedArticle
            if let articleURI = scrappedArticle.searched?.webURI {
                ScrapManager.readArticle(.search, articleURI)
            }
            navigationController?.pushViewController(articleView, animated: true)
        case .web:
            let scrappedArticle = resultController.object(at: indexPath)
            DispatchQueue.main.async { [weak self] in
                guard
                    let self = self ,
                    let articleView = storyboard.instantiateViewController(
                        withIdentifier: "ArticleWebViewController"
                        ) as? ArticleWebViewController else { return }
                articleView.articleURLString = scrappedArticle.web?.webURL
                if let webData = scrappedArticle.web?.webData {
                    articleView.webData = webData as Data
                }
                if let urlString = scrappedArticle.web?.webURL {
                    ScrapManager.readArticle(.web ,urlString)
                }
                self.navigationController?.pushViewController(articleView, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let scrappedArticle = resultController.object(at: indexPath)
        let articleType = scrappedArticle.articleTypeEnum
        var articleIdentifier: String? {
            switch articleType {
            case .search:
                return scrappedArticle.searched?.webURI
            case .web:
                return scrappedArticle.web?.webURL
            case .webExtracted:
                return scrappedArticle.webExtracted?.webURL
            }
        }
        let markAsReadAction = customUIContextualAction(
        .markAsRead,
        nil,
        nil,
        articleIdentifier,
        articleType
    ) { [weak self] _ in
            guard let self = self else { return }
            self.setupScrapBadgeValue()
        }
        return UISwipeActionsConfiguration(actions: [markAsReadAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = customUIContextualAction(.delete, nil, nil, nil, nil) { [weak self] _ in
            guard let self = self else { return }
            let deletedArticle = self.resultController.object(at: indexPath)
            ScrapManager.removeArticle(deletedArticle)
//            self.isArticleDeleted = true
//            self.scrappedArticles = tempArticles
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateResult()
            self.setupScrapBadgeValue()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ScrapViewController: ScrapFilterDelegate {
    func filterArticles(_ category: ArticleCategory) {
        switch category {
        case .all:
//            scrappedArticles = ScrapManager.fetchArticles()
            title = "Scrap"
        default:
            title = "\(category)".capitalized
//            scrappedArticles = ScrapManager.fetchArticles(category)
        }
//        if let scrappedArticles = scrappedArticles,
//            scrappedArticles.count > 0 {
//            tableView.scrollToRow(
//                at: IndexPath(row: 0, section: 0),
//                at: .top,
//                animated: true
//            )
//        }
    }
}

extension ScrapViewController: NSFetchedResultsControllerDelegate {
    
}

extension ScrapViewController {
    public func setupScrapBadgeValue() {
        let count = ScrapManager.countArticle(false)
        if count == 0 {
            tabBarController?.tabBar.items?[2].badgeValue = nil
        } else {
            tabBarController?.tabBar.items?[2].badgeValue = "\(count)"
        }
    }
}
