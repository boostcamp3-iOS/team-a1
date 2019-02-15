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
    private let articleImage: ArticleImage = ArticleImage()
    private var loadingView: LoadingView?
    private var defaultView: DefaultLabelView?
    private var topOffset: CGFloat = UIApplication.shared.statusBarOrientation.isLandscape ? 44 : 64
    private var tableViewContentOffsetY: CGFloat = 0
    private var tableViewScrollCount: (down: Int, up: Int) = (0, 0)
    private var searchBarTextField: UITextField?
    private var searchBarIsPresented: Bool = true
    private var transitionManager = PresentationManager()
    private var articles: [Article]?
    private var defaultLabel: UILabel = UILabel()
    private var searchKeyword: String = ""
    private var page: Int = 1
    private var totalPage: Int = 0
    private var isMoreLoading: Bool = false
    private var isPresentedCheck: Bool = true
    private var heightAtIndexPath = [IndexPath: Float]()
    private lazy var searchFilter = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuppDelegate()
        setupSearchBar()
        setupTableView()
        setupNavigationBar()
        registerArticleCell()
        setupFilterItem()
        userFilter()
        setDefaultView(message: "Please Search 🔎")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isPresentedCheck = searchBarIsPresented
    }
    
    private func setLoadingView() {
        let loadingViewFrame = CGRect(
            x: 0,
            y: 0, 
            width: 100,
            height: 100
        )
        loadingView = LoadingView(frame: loadingViewFrame)
        guard let loadView = loadingView else { return } 
        loadView.center = self.view.center
        self.view.addSubview(loadView)        
    }
    
    private func setDefaultView(message: String) {
        let defaultViewFrame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: 150
        )
        defaultView = DefaultLabelView(frame: defaultViewFrame)
        guard let defaultView = defaultView else { return } 
        defaultView.defaultMessage.text = message
        defaultView.center = self.view.center
        self.view.addSubview(defaultView)  
    }
    
    private func setuppDelegate() {
        uiSearchBar.delegate = self
        uiTableView.delegate = self
        uiTableView.dataSource = self
        uiTableView.prefetchDataSource = self
    }
    
    private func setupSearchBar() {
        uiSearchBar.backgroundImage = UIImage()
        guard 
            let searchBarTextfield = uiSearchBar.value(
                forKey: "searchField"
            ) as? UITextField else { return }
        searchBarTextfield.backgroundColor = UIColor.lightGray
        searchBarTextfield.textColor = UIColor.black
    }
    
    private func setupTableView() {
        uiTableView.contentInset = UIEdgeInsets(top: topOffset, left: 0, bottom: 0, right: 0)
        uiTableView.separatorStyle = .none
        uiTableView?.rowHeight = UITableView.automaticDimension
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.backgroundColor = UIColor.white
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    private func registerArticleCell() {
        let articleFeedNib = UINib(nibName: "ArticleFeedTableViewCell", bundle: nil)
        uiTableView.register(articleFeedNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setMessageBySearchState(to message: String) {        
        defaultLabel.text = message
        defaultLabel.frame.size = CGSize(width: 200, height: 50)
        defaultLabel.center = self.view.center
        defaultLabel.textAlignment = .center
        view.addSubview(defaultLabel)
    }
    
    private func checkFilterStatus(using searchFilter: [String: String], type: ArticleType) {
        guard let keyword = searchFilter["keyword"], 
            let language = searchFilter["language"], 
            let sort = searchFilter["sort"] 
            else { return }
        switch type {
        case .load:
            loadArticles(
                keyword: keyword,
                language: language, 
                sort: sort
            )
        case .loadMore:
            loadMoreArticles(
                keyword: keyword, 
                language: language, 
                sort: sort
            )
        }
    }
    
    private func loadArticles(
        keyword: String,
        language: String,
        sort: String
    ) {
        articles = nil
        self.defaultView?.removeFromSuperview()
        self.uiTableView.reloadData()
        self.setLoadingView()
        APIManager.fetchArticles(
            keyword: searchKeyword, 
            keywordLoc: keyword,
            lang: language, 
            articlesSortBy: sort, 
            articlesPage: 1
        ) { (result) in
            switch result {
            case .success(let articleData):
                self.articles = articleData.articles.results
                self.totalPage = articleData.articles.pages
                DispatchQueue.main.async {
                    self.uiTableView.reloadData()
                    self.loadingView?.removeFromSuperview()
                    if self.articles?.count == 0 {
                        self.setDefaultView(message: "No Results 🔎")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadMoreArticles(
        keyword: String,
        language: String,
        sort: String
    ) {
        if page >= totalPage { return }
        page += 1
        APIManager.fetchArticles(
            keyword: keyword,
            keywordLoc: keyword, 
            lang: language, 
            articlesSortBy: sort,
            articlesPage: page
        ) { (result) in
            switch result {
            case .success(let articleData):
                self.articles?.append(contentsOf: articleData.articles.results)
                DispatchQueue.main.async {
                    self.uiTableView.reloadData()
                    self.isMoreLoading = false
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupFilterItem() {
        navigationFilterItem.addTarget(self, action: #selector(filterItemTapAtion), for: .touchUpInside)
    }
    
    @objc private func filterItemTapAtion() {
        guard
            let filterViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "SearchFilterViewController"
            ) as? SearchFilterViewController else { return }
        filterViewController.settingDelegate = self
        filterViewController.filterValue = searchFilter
        filterViewController.transitioningDelegate = transitionManager
        filterViewController.modalPresentationStyle = .custom
        present(filterViewController, animated: true)
    }
    
}

// MARK: TableView
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier, 
                for: indexPath
            ) as? ArticleFeedTableViewCell else {
                return UITableViewCell() 
        }
        guard let article = articles?[indexPath.row] else { return UITableViewCell() }
        cell.settingData(article: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
        guard let articleView
            = storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController")
                as? ArticleDetailViewController,
        let article = articles?[indexPath.row] else { return }
        articleView.articleDetail = articles?[indexPath.row]
        ScrapManager.scrapArticle(
            article: article,
            category: ArticleCategory(containString: "\(article.categories.first)"),
            imageData: nil)
        self.navigationController?.pushViewController(articleView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true 
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            print("scrap")
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let scrapButton = UITableViewRowAction(style: .default, title: "SCRAP") { (_, indexPath) in
            tableView.dataSource?.tableView!(tableView, commit: .insert, forRowAt: indexPath)
            return
        }
        scrapButton.backgroundColor = UIColor.white
        return [scrapButton]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = Float(cell.frame.size.height)
        heightAtIndexPath.updateValue(height, forKey: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath[indexPath] {
            return CGFloat(height)
        } 
        return UITableView.automaticDimension
    }
    
    func shouldLoadAdditionalData(minimumHeightPortionToLoadAdditionalData: CGFloat, contentHeight: CGFloat) -> Bool {
        if minimumHeightPortionToLoadAdditionalData > 0 &&
            minimumHeightPortionToLoadAdditionalData < contentHeight * 0.2 {
            return true
        }
        return false
    }
}

// MARK: ScrollView
extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreLoading {
            let scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y 
            if shouldLoadAdditionalData(
                minimumHeightPortionToLoadAdditionalData: scrollPosition,
                contentHeight: scrollView.contentSize.height
            ) {
                checkFilterStatus(using: searchFilter, type: ArticleType.loadMore)
                isMoreLoading.toggle()
            }
        }
        if searchBarIsPresented && tableViewContentOffsetY < scrollView.contentOffset.y {
            scrollViewCheckCount(.down)
        } else if !searchBarIsPresented && tableViewContentOffsetY > scrollView.contentOffset.y {
            scrollViewCheckCount(.up)
        } 
        tableViewContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewCheckCount(_ scrollDirection: ScrollDirection) {
        let directionIsDown = scrollDirection == .down ? true : false
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
        if !isPresentedCheck {
            self.uiTableView.contentInset.top = directionIsDown ? 0 : self.topOffset
            UIView.animate(withDuration: 0.3) { 
                self.uiSearchBarOuterView.alpha = 1
                self.isPresentedCheck.toggle()
            }
        } else {
            UIView.animate(withDuration: 0.5) { 
                self.uiSearchBarOuterView.center.y += directionIsDown ? (-1) * self.topOffset : self.topOffset
                self.uiTableView.contentInset.top = directionIsDown ? 0 : self.topOffset
                self.uiSearchBarOuterView.alpha = directionIsDown ? 0 : 1.0
            }
        }
    }
}

// MARK: SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        uiSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.title = searchBar.text ?? "Search"
        if let getSearchKeyword = searchBar.text, getSearchKeyword.count > 0 {
            searchKeyword = getSearchKeyword
            checkFilterStatus(using: searchFilter, type: ArticleType.load)
            defaultLabel.removeFromSuperview()
        }
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

// MARK: Prefetch
extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({
            guard let articleUrl = articles?[$0.row].image else { return }
            articleImage.loadImageUrl(articleUrl: articleUrl)
        })
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({
            guard let articleUrl = articles?[$0.row].image else { return }
            articleImage.cancelLoadingImage(articleUrl)
        })    
    }
}

// MARK: Filter Delegate
extension SearchViewController: FilterSettingDelegate {
    func observeUserSetting(
        keyword: String, 
        sort: String,
        category: String,
        language: String
    ) {
        updateUserFilter(
            keyword: keyword, 
            sort: sort, 
            category: category,
            language: language
        )
        UserDefaults.standard.set(searchFilter, forKey: "searchFilter")
    }
    
    private func updateUserFilter(
        keyword: String, 
        sort: String, 
        category: String,
        language: String
    ) {
        searchFilter.updateValue(keyword, forKey: "keyword")
        searchFilter.updateValue(sort, forKey: "sort")
        searchFilter.updateValue(category, forKey: "category")
        searchFilter.updateValue(language.lowercased(), forKey: "language")
    }
    
    private func userFilter() {
        guard 
            let userFilter = UserDefaults.standard.dictionary(forKey: "searchFilter") else {
                return
        }
        if let keyword = userFilter["keyword"] as? String, 
            let sort = userFilter["sort"] as? String,
            let category = userFilter["category"] as? String,
            let language = userFilter["language"] as? String {
            updateUserFilter(keyword: keyword, sort: sort, category: category, language: language)
        }
    }
}
