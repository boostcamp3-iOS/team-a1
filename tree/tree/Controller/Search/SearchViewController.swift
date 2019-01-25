//
//  SearchViewController.swift
//  tree
//
//  Created by Hyeontae on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var uiSearchBar: UISearchBar!
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var navigationFilterItem: UIBarItem!
    
    private let cellIdentifier: String = "ArticleFeedTableViewCell"
    
    private var lastContentOffset: CGFloat = -64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
        searchBarSetting()
        tableViewSetting()
        navigationBarSetting()
        registerArticleCell()
    }
    
    func delegateSetting() {
        uiSearchBar.delegate = self
        uiTableView.delegate = self
        uiTableView.dataSource = self
    }
    
    func searchBarSetting() {
        uiSearchBar.backgroundImage = UIImage()
        guard let searchBarTextfield: UITextField = uiSearchBar.value(forKey: "searchField") as? UITextField else { return }
        searchBarTextfield.backgroundColor = UIColor.lightGray
        searchBarTextfield.textColor = UIColor.black
    }
    
    func tableViewSetting() {
        uiTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        uiTableView.separatorStyle = .none
    }
    
    func navigationBarSetting() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.backgroundColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func registerArticleCell() {
        uiTableView.register(UINib(nibName: "ArticleFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleFeedTableViewCell")
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleFeedTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        let articleView = storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController")
        self.navigationController?.pushViewController(articleView, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}
