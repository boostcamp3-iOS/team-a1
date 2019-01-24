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

    let cellIdentifier: String = "ArticleTableViewCell"
    
    private var lastContentOffset: CGFloat = -64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSearchBar.delegate = self
        uiTableView.delegate = self
        uiTableView.dataSource = self
        
        searchBarSetting()
        tableViewSetting()
        navigationBarSetting()
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
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
}
