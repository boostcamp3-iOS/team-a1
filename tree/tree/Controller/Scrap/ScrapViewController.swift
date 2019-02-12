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
    
    private var articleDeleted: Bool = false
    public var scrappedArticles: [ScrappedArticle]? {
        didSet {
            if !articleDeleted {
                tableView.reloadData()
            } else {
                articleDeleted = false
            }
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        filterButtonSetup()
        tableDataSetup()
    }
    
    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func filterButtonSetup() {
        filterButton.addTarget(
            self,
            action: #selector(filterButtonDidTap),
            for: .touchUpInside)
    }
    
    private func tableDataSetup() {
        scrappedArticles = ScrapManager.fetchArticles()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let scrappedArticles = scrappedArticles else { return UITableViewCell() }
        cell.textLabel?.text = scrappedArticles[indexPath.row].articleTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
        ) -> UISwipeActionsConfiguration? {
            let markAsReadAction: UIContextualAction =
                UIContextualAction(style: .normal, title: "Mark as Read") {
                    (action: UIContextualAction,
                    view: UIView,
                    completion: (Bool) -> Void ) in
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
        if category == .all {
            scrappedArticles = ScrapManager.fetchArticles()
        } else {
            scrappedArticles = ScrapManager.fetchArticles(category)
        }
    }
}
