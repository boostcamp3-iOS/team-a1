//
//  ScrapFilterViewController.swift
//  tree
//
//  Created by Hyeontae on 05/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ScrapFilterViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "ScrapFilterTableViewCell"
    private lazy var categories: [ArticleCategory] = {
        ArticleCategory.allCases.filter({
            if $0 == .all { return true }
            return ScrapManager.countArticle(category: $0, nil) != 0
        })
    }()
    
    weak var filterDelegate: ScrapFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderViewGesture()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: cellIdentifier, bundle: nil),
            forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func setupHeaderViewGesture() {
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(headerViewSwipeDownAction)
        )
        swipeDownGestureRecognizer.direction = .down
        headerView.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    @objc private func headerViewSwipeDownAction(_ sender: UISwipeGestureRecognizer) {
       dismiss(animated: true)
    }
}

extension ScrapFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? ScrapFilterTableViewCell else {
                    return UITableViewCell()
        }
        if indexPath.row == 0 {
            cell.setAllCategory(width: view.bounds.width - 32)
        } else {
            cell.configure(categories[indexPath.row], width: view.bounds.width - 32)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        filterDelegate?.filterArticles(categories[indexPath.row])
        dismiss(animated: true)
    }
}
