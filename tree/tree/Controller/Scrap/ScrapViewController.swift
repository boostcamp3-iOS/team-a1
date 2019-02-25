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
    
    private let articleFeedCellIdentifier = "ScrapTableViewCell"
    private let liveCellIdentifier = "KeywordDetailArticleCell"
    private var isArticleDeleted: Bool = false
    public var scrappedArticles: [ScrappedArticle]? {
        didSet {
            if tableView != nil && !isArticleDeleted {
                tableView.reloadData()
            } else if isArticleDeleted {
                isArticleDeleted = false
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewData()
        registerArticleCell()
        setupScrapBadgeValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScrapBadgeValue()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func setupTableViewData() {
        scrappedArticles = ScrapManager.fetchArticles()
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
        guard let scrappedArticles = scrappedArticles else { return 0 }
        return scrappedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let scrappedArticles = scrappedArticles else {
            fatalError(FatalError.invalidCell.localizedDescription)
        }
        let scrappedArticle = scrappedArticles[indexPath.row]
        guard let articleTypeString = scrappedArticle.articleType else {
            return UITableViewCell()
        }
        let articleType = ScrappedArticleType(type: articleTypeString)
        
        switch articleType {
        case .search:
            guard let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: articleFeedCellIdentifier,
                    for: indexPath
                    ) as? ArticleFeedTableViewCell else {
                        fatalError(FatalError.invalidCell.localizedDescription)
            }
            cell.settingData(scrappedArticle: scrappedArticles[indexPath.row])
            return cell
        case .webExtracted:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: liveCellIdentifier, for: indexPath)
                as? KeywordDetailArticleCell else {
                    fatalError(FatalError.invalidCell.localizedDescription)
            }
            cell.configure(scrappedArticles[indexPath.row])
            return cell
        case .web:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: liveCellIdentifier, for: indexPath)
                as? KeywordDetailArticleCell else {
                    fatalError(FatalError.invalidCell.localizedDescription)
            }
            cell.configure(scrappedArticles[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let scrappedArticles = scrappedArticles else { return }
        let scrappedArticle: ScrappedArticle = scrappedArticles[indexPath.row]
        guard let articleTypeString = scrappedArticle.articleType else { return }
        let articleType = ScrappedArticleType.init(type: articleTypeString)
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        switch articleType {
        case .search:
            guard
                let articleView = storyboard.instantiateViewController(
                    withIdentifier: "ArticleDetailViewController"
                    ) as? ArticleDetailViewController else { return }
            articleView.scrappedArticleDetail = scrappedArticle
            if let articleUri = scrappedArticle.articleUri {
                ScrapManager.readArticle(.search ,articleUri)
            }
            self.navigationController?.pushViewController(articleView, animated: true)
        case .webExtracted:
            guard
                let articleView = storyboard.instantiateViewController(
                    withIdentifier: "ArticleDetailViewController"
                    ) as? ArticleDetailViewController else { return }
            articleView.scrappedArticleDetail = scrappedArticle
            if let articleURL = scrappedArticle.articleURL {
                ScrapManager.readArticle(.webExtracted ,articleURL)
            }
            self.navigationController?.pushViewController(articleView, animated: true)
        case .web:
            DispatchQueue.main.async {
                guard
                    let articleView = storyboard.instantiateViewController(
                        withIdentifier: "ArticleWebViewController"
                        ) as? ArticleWebViewController,
                    let scrappedArticles = self.scrappedArticles else { return }
                let scrappedArticle = scrappedArticles[indexPath.row]
                articleView.articleURLString = scrappedArticle.articleURL
                if let webData = scrappedArticle.articleData {
                    articleView.webData = webData as Data
                }
                if let urlString = scrappedArticle.articleURL {
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
        guard let scrappedArticles = scrappedArticles else {
            return nil
        }
        let scrappedArticle = scrappedArticles[indexPath.row]
        guard let articleTypeString = scrappedArticle.articleType else {
            return nil
        }
        let articleType = ScrappedArticleType(type: articleTypeString)
        var articleIdentifier: String? {
            switch articleType {
            case .search:
                return scrappedArticles[indexPath.row].articleUri
            case .web, .webExtracted:
                return scrappedArticles[indexPath.row].articleURL
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
            guard var tempArticles = self.scrappedArticles else { return }
            ScrapManager.removeArticle(tempArticles.remove(at: indexPath.row))
            self.isArticleDeleted = true
            self.scrappedArticles = tempArticles
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.setupScrapBadgeValue()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension ScrapViewController: ScrapFilterDelegate {
    func filterArticles(_ category: ArticleCategory) {
        switch category {
        case .all:
            scrappedArticles = ScrapManager.fetchArticles()
        default:
            scrappedArticles = ScrapManager.fetchArticles(category)
        }
        if let scrappedArticles = scrappedArticles,
            scrappedArticles.count > 0 {
            tableView.scrollToRow(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: true
            )
        }
        
    }
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
