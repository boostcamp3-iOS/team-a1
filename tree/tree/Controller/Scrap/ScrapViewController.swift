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
    
    private lazy var scrappedArticles: [ScrappedArticle] = {
        ScrapManager.fetchArticles()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetup()
        filterButtonSetup()
    }
    
    func delegateSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func filterButtonSetup() {
        filterButton.addTarget(
            self,
            action: #selector(filterButtonDidTap),
            for: .touchUpInside)
    }
    
    @objc func filterButtonDidTap(_ sender: UIButton) {
        guard let tempUIViewController =
            UIStoryboard.init(name: "ScrapFilter", bundle: nil)
                .instantiateViewController(withIdentifier: "ScrapFilterViewController")
                as? ScrapFilterViewController else {
            return
        }
        tempUIViewController.delegate = self
        present(tempUIViewController, animated: true)
    }
    
    func fetchAndReload(selectedCategory category: ArticleCategory) {
        if category == .all {
            scrappedArticles = ScrapManager.fetchArticles()
        } else {
            scrappedArticles = ScrapManager.fetchArticles(category)
        }
        tableView.reloadData()
    }
}

extension ScrapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scrappedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = scrappedArticles[indexPath.row].articleTitle
        return cell
    }
}

extension ScrapViewController: ScrapFilterDelegate {
    func filterArticles(_ article: ArticleCategory) {
        fetchAndReload(selectedCategory: article)
    }
}
