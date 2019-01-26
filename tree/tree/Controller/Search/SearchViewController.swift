//
//  SearchViewController.swift
//  tree
//
//  Created by Hyeontae on 24/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var uiSearchBarOuterView: UIView!
    @IBOutlet weak var uiSearchBar: UISearchBar!
    @IBOutlet weak var uiTableView: UITableView!
    @IBOutlet weak var navigationFilterItem: UIBarItem!
    
    private let cellIdentifier: String = "ArticleTableViewCell"
    private var topOffset: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 44 : 64
    private var tableViewContentOffsetY: CGFloat = 0
    private var tableViewScrollCount: (down: Int, up: Int) = (0, 0)
    private var searchBarTextField: UITextField?
    private var searchBarPresented: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
        searchBarSetting()
        tableViewSetting()
        navigationBarSetting()
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
        uiTableView.contentInset = UIEdgeInsets(top: topOffset, left: 0, bottom: 0, right: 0)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableViewContentOffsetY < scrollView.contentOffset.y {
            tableViewScrollCount.down += 1
            tableViewScrollCount.up = 0
            if tableViewScrollCount.down > 15 {
                scrollSettingFunction(.down)
            }
        } else {
            tableViewScrollCount.down = 0
            tableViewScrollCount.up += 1
            if tableViewScrollCount.up > 15 {
                scrollSettingFunction(.up)
            }
        }
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollSettingFunction(_ direction: ScrollDirection) {
        switch direction {
        case .up where !searchBarPresented:
            searchBarPresented = true
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.uiSearchBarOuterView.center.y += self.topOffset
                self.uiTableView.contentInset.top = self.topOffset
                self.uiSearchBarOuterView.alpha = 1.0
            }
        case .down where searchBarPresented:
            searchBarPresented = false
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.uiSearchBarOuterView.center.y -= self.topOffset
                self.uiTableView.contentInset.top = 0
                self.uiSearchBarOuterView.alpha = 0
            }
        default:
            break
        }
        tableViewScrollCount = (0,0)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        uiSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.title = searchBar.text!
        searchBarHideAndSetting()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarTextField?.text = ""
        searchBarHideAndSetting()
    }
    
    func searchBarHideAndSetting() {
        uiSearchBar.setShowsCancelButton(false, animated: true)
        uiSearchBar.resignFirstResponder()
    }
}
