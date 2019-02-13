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
    
    private var articleDeleted: Bool = false
    public var scrappedArticles: [ScrappedArticle]? {
        didSet {
            if tableView != nil && !articleDeleted {
                tableView.reloadData()
            } else if articleDeleted {
                articleDeleted = false
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFilterButton()
        setupTableViewData()
        registerArticleCell()
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
        guard let tempUIViewController =
            UIStoryboard.init(name: "ScrapFilter", bundle: nil)
                .instantiateViewController(withIdentifier: "ScrapFilterViewController")
                as? ScrapFilterViewController else {
            return
        }
        tempUIViewController.filterDelegate = self
        present(tempUIViewController, animated: true)
    }
}

extension ScrapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let scrappedArticles = scrappedArticles else { return 0 }
        return scrappedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
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
                ) as? ArticleDetailViewController else { return }
        self.navigationController?.pushViewController(articleView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
        let markAsReadAction: UIContextualAction
            = UIContextualAction(
                style: .normal,
                title: "Mark as Read") { (_, _, _ completion) in
                    completion(true)
        }
        markAsReadAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [markAsReadAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard var tempArticles = self.scrappedArticles else {
                return
            }
            ScrapManager.removeArticle(tempArticles.remove(at: indexPath.row))
            articleDeleted = true
            scrappedArticles = tempArticles
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
