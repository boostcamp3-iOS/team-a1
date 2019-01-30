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
    @IBOutlet weak var navigationFilterItem: UIButton!
    
    private let cellIdentifier: String = "ArticleFeedTableViewCell"
    private var topOffset: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 44 : 64
    private var tableViewContentOffsetY: CGFloat = 0
    private var tableViewScrollCount: (down: Int, up: Int) = (0, 0)
    private var searchBarTextField: UITextField?
    private var searchBarIsPresented: Bool = true
    private var transitionDelegate = PresentationManager()
    private var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateSetting()
        searchBarSetting()
        tableViewSetting()
        navigationBarSetting()
        registerArticleCell()
        filterItemSetting()
    }
    
    private func delegateSetting() {
        uiSearchBar.delegate = self
        uiTableView.delegate = self
        uiTableView.dataSource = self
    }
    
    private func searchBarSetting() {
        uiSearchBar.backgroundImage = UIImage()
        guard let searchBarTextfield: UITextField = uiSearchBar.value(forKey: "searchField") as? UITextField else { return }
        searchBarTextfield.backgroundColor = UIColor.lightGray
        searchBarTextfield.textColor = UIColor.black
    }
    
    private func tableViewSetting() {
        uiTableView.contentInset = UIEdgeInsets(top: topOffset, left: 0, bottom: 0, right: 0)
        uiTableView.separatorStyle = .none
    }
    
    private func navigationBarSetting() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.backgroundColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    private func registerArticleCell() {
        let articleFeedNib = UINib(nibName: "ArticleFeedTableViewCell", bundle: nil)
        uiTableView.register(articleFeedNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func getArticlesFromServer(keyword: String) {
        APIManager.getArticles(keyword: keyword, keywordLoc: "title", lang: "eng", articlesSortBy: "date", articlesPage: 1) { (result) in
            switch result {
            case .success(let articleData):
                self.articles = articleData.articles.results
                DispatchQueue.main.async {
                    self.uiTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func filterItemSetting() {
        navigationFilterItem.addTarget(self, action: #selector(filterItemTapAtion), for: .touchUpInside)
    }
    
    @objc private func filterItemTapAtion() {
        guard let filterViewController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchFilterViewController") else { return }
        filterViewController.transitioningDelegate = transitionDelegate
        filterViewController.modalPresentationStyle = .custom
        present(filterViewController, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleFeedTableViewCell else { return UITableViewCell() }
        guard let article = articles?[indexPath.row] else { return UITableViewCell() }
        cell.settingData(article: article)
        cell.articleImageView.image = nil
        cell.position = indexPath.row
        
        DispatchQueue.global().async {
            if let articleImage = article.image {
                guard let imageURL = URL(string: articleImage) else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                DispatchQueue.main.async {
                    if cell.position == indexPath.row {
                        cell.settingImage(image: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleFeedTableViewCell else { return }
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        guard let articleView = storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController else { return }
        
        articleView.articleDetail = articles?[indexPath.row]
        
        if let articleImage = cell.articleImageView.image {
            articleView.articleImage = articleImage
        }
        
        self.navigationController?.pushViewController(articleView, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBarIsPresented && tableViewContentOffsetY < scrollView.contentOffset.y {
            scrollViewCheckCount(.down)
        } else if !searchBarIsPresented && tableViewContentOffsetY > scrollView.contentOffset.y {
            scrollViewCheckCount(.up)
        }
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewCheckCount(_ scrollDirection: ScrollDirection) {
        let directionIsDown: Bool = scrollDirection == .down ? true : false
        tableViewScrollCount.down += directionIsDown == true ? 1 : 0
        tableViewScrollCount.up += directionIsDown == true ? 0 : 1
        if tableViewScrollCount.down > 15 || tableViewScrollCount.up > 5 {
            scrollSettingFunction(directionIsDown ? .down : .up)
        }
    }
    
    func scrollSettingFunction(_ direction: ScrollDirection) {
        switch direction {
        case .up:
            searchBarIsPresented = true
            searchBarShowAndHideAnimation(.up)
        case .down:
            searchBarIsPresented = false
            searchBarShowAndHideAnimation(.down)
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
        getArticlesFromServer(keyword: searchBar.text ?? "")
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
