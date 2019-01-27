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
    
    private let cellIdentifier: String = "ArticleFeedTableViewCell"
    private var topOffset: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 44 : 64
    private var tableViewContentOffsetY: CGFloat = 0
    private var tableViewScrollCount: (down: Int, up: Int) = (0, 0)
    private var searchBarTextField: UITextField?
    private var searchBarIsPresented: Bool = true
    
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
        uiTableView.contentInset = UIEdgeInsets(top: topOffset, left: 0, bottom: 0, right: 0)
        uiTableView.separatorStyle = .none
    }
    
    func navigationBarSetting() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.backgroundColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func registerArticleCell() {
        let articleFeedNib = UINib(nibName: "ArticleFeedTableViewCell", bundle: nil)
        uiTableView.register(articleFeedNib, forCellReuseIdentifier: cellIdentifier)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableViewContentOffsetY < scrollView.contentOffset.y {
            scrollViewCheckCount(.down)
        } else {
            scrollViewCheckCount(.up)
        }
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewCheckCount(_ scrollDirection: ScrollDirection) {
        let directionIsDown: Bool = scrollDirection == .down ? true : false
        tableViewScrollCount.down += directionIsDown == true ? 1 : 0
        tableViewScrollCount.up += directionIsDown == true ? 0 : 1
        if tableViewScrollCount.down > 15 || tableViewScrollCount.up > 15 {
            scrollSettingFunction(directionIsDown ? .down : .up)
        }
    }
    
    func scrollSettingFunction(_ direction: ScrollDirection) {
        switch direction {
        case .up where !searchBarIsPresented:
            searchBarIsPresented = true
            searchBarShowAndHideAnimation(.up)
        case .down where searchBarIsPresented:
            searchBarIsPresented = false
            searchBarShowAndHideAnimation(.down)
        default:
            break
        }
        tableViewScrollCount = (0, 0)
    }
    
    func searchBarShowAndHideAnimation(_ direction: ScrollDirection) {
        let directionIsDown = direction == .down ? true : false
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.uiSearchBarOuterView.center.y += directionIsDown ? (-1) * self.topOffset : self.topOffset
            self.uiTableView.contentInset.top = directionIsDown ? 0 : self.topOffset
            self.uiSearchBarOuterView.alpha = directionIsDown ? 0 : 1.0
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        uiSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.title = searchBar.text ?? "Search"
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
