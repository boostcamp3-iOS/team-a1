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
    @IBOutlet weak var filterButton: UIButton!
    
    private let cellIdentifier = "ScrapTableViewCell"
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
        setupFilterButton()
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
    }
    
    private func setupFilterButton() {
        filterButton.addTarget(
            self,
            action: #selector(filterButtonDidTap),
            for: .touchUpInside)
    }
    
    private func setupTableViewData() {
        scrappedArticles = ScrapManager.fetchArticles()
    }
    
    private func registerArticleCell() {
        let articleFeedNib = UINib(nibName: "ArticleFeedTableViewCell", bundle: nil)
        tableView.register(articleFeedNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    @objc func filterButtonDidTap(_ sender: UIButton) {
        guard let scrapFilterViewController =
            UIStoryboard.init(name: "ScrapFilter", bundle: nil)
                .instantiateViewController(withIdentifier: "ScrapFilterViewController")
                as? ScrapFilterViewController else { return }
        scrapFilterViewController.filterDelegate = self
        present(scrapFilterViewController, animated: true)
    }
}

extension ScrapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let scrappedArticles = scrappedArticles else { return 0 }
        return scrappedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? ArticleFeedTableViewCell else { return UITableViewCell() }
        guard let scrappedArticles = scrappedArticles else { return UITableViewCell() }
        cell.settingData(scrappedArticle: scrappedArticles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        guard
            let articleView = storyboard.instantiateViewController(
                withIdentifier: "ArticleDetailViewController"
                ) as? ArticleDetailViewController,
            let scrappedArticleData = scrappedArticles?[indexPath.row] else { return }
        articleView.scrappedArticleDetail = scrappedArticleData
        if let articleUri = scrappedArticleData.articleUri {
            ScrapManager.readArticle(articleUri)
        }
        self.navigationController?.pushViewController(articleView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let scrappedArticle = scrappedArticles else {
            return nil
        }
        let markAsReadAction = customUIContextualAction(
        .markAsRead,
        nil,
        nil,
        scrappedArticle[indexPath.row].articleUri
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
        let deleteAction = customUIContextualAction(.delete, nil, nil, nil) { [weak self] _ in
            guard let self = self else { return }
            guard var tempArticles = self.scrappedArticles else { return }
            ScrapManager.removeArticle(tempArticles.remove(at: indexPath.row))
            self.isArticleDeleted = true
            self.scrappedArticles = tempArticles
            tableView.deleteRows(at: [indexPath], with: .automatic)
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


