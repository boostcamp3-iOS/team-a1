//
//  KeywordDetailViewController.swift
//  tree
//
//  Created by ParkSungJoon on 07/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

class KeywordDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var keywordData: TrendingSearch? {
        didSet {
            guard let keyword = keywordData?.title.query else { return }
            loadGraphData(to: keyword, startDate, endDate)
            articleData = keywordData?.articles
        }
    }
    var graphData: Graph? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var startDate: String {
        let oneMonth = TimeIntervalTypes.oneMonth.value
        let date = Date(timeInterval: -oneMonth, since: Date())
        return dateFormatter.string(from: date)
    }
    private var endDate: String {
        let oneDay = TimeIntervalTypes.oneDay.value
        let date = Date(timeInterval: -oneDay, since: Date())
        return dateFormatter.string(from: date)
    }
    private var articleData: [KeywordArticles]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .automatic)
            }
        }
    }
    private var isSelected: Bool = false 
    private var loadingView: LoadingView?
    private let timeUnit = TimeUnitTypes.week.value
    private let graphCellIdentifier = "KeywordDetailGraphCell"
    private let headerCellIdentifier = "TrendListHeaderCell"
    private let articleCellIdentifier = "KeywordDetailArticleCell"
    private let appleGothicNeoBold = "AppleSDGothicNeo-Bold"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXIB()
        setupTableView()
        navigationBar.topItem?.title = keywordData?.title.query
    }
    
    @IBAction func backButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerXIB() {
        let graphNib = UINib(nibName: graphCellIdentifier, bundle: nil)
        tableView.register(graphNib, forCellReuseIdentifier: graphCellIdentifier)
        let headerNib = UINib(nibName: headerCellIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: headerCellIdentifier)
        let articleNib = UINib(nibName: articleCellIdentifier, bundle: nil)
        tableView.register(articleNib, forCellReuseIdentifier: articleCellIdentifier)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIScreen.main.bounds.width,
            bottom: 0,
            right: 0
        )
    }
    
    private func loadGraphData(to keyword: String, _ startDate: String, _ endDate: String) {
        let keywordGroups: [[String: Any]] = [[
            "groupName": keyword,
            "keywords": [keyword]
            ]]
        BoosterManager.requestGraphData(
            startDate: startDate,
            endDate: endDate,
            timeUnit: timeUnit,
            keywordGroups: keywordGroups
        ) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let graphData):
                self.graphData = graphData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetctExtractArticle(
        urlString: String, 
        completion: @escaping(ArticleViewerType, ExtractArticle?) -> Void) {
        BoosterManager.extractArticle(url: urlString) { (result) in
            switch result {
            case .success(let data):
                completion(.articleViewer, data)
            case .failure:
                completion(.webViewer, nil)
            }
        }
    }
    
    private func setupLoadingView() {
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
}

private enum KeywordDetailSection: Int {
    case gragh
    case articleList
    
    init(section: Int) {
        switch section {
        case 0:
            self = .gragh
        default:
            self = .articleList
        }
    }
}

extension KeywordDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if articleData != nil {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch KeywordDetailSection(section: section) {
        case .gragh:
            return 1
        case .articleList:
            if let articleData = articleData {
                return articleData.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let headerCell = tableView.dequeueReusableCell(
                withIdentifier: headerCellIdentifier
                ) as? TrendListHeaderCell else {
                    return UIView()
        }
        headerCell.headerLabel.font = UIFont(name: appleGothicNeoBold, size: 17)
        switch KeywordDetailSection(section: section) {
        case .gragh:
            headerCell.headerLabel.text = HeaderTitles.changeInteresting.rawValue
        case .articleList:
            headerCell.headerLabel.text = HeaderTitles.relatedArticles.rawValue
        }
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch KeywordDetailSection(section: indexPath.section) {
        case .gragh:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: graphCellIdentifier,
                    for: indexPath
                    ) as? KeywordDetailGraphCell else {
                        fatalError(FatalError.invalidCell.localizedDescription)
            }
            cell.graphData = graphData?.results.first
            return cell
        case .articleList:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: articleCellIdentifier,
                    for: indexPath
                    ) as? KeywordDetailArticleCell else {
                        fatalError(FatalError.invalidCell.localizedDescription)
            }
            if let articleData = articleData {
                cell.configure(articleData[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = articleData?[indexPath.row].url else { return }
        if !isSelected { 
            isSelected.toggle()
            switch KeywordDetailSection(section: indexPath.section) {
            case .gragh:
                return
            case .articleList:
                setupLoadingView()
                fetctExtractArticle(
                    urlString: url,
                    completion: { [weak self] (viewerType, data) in
                    guard let self = self else { return }
                    let storyboard = UIStoryboard(name: "ArticleDetail", bundle: nil)
                    switch viewerType {
                    case .webViewer:
                        DispatchQueue.main.async {
                            guard 
                                let articleView = storyboard.instantiateViewController(
                                    withIdentifier: "ArticleWebViewController"
                                    ) as? ArticleWebViewController else { return }
                            articleView.articleURLString = "\(self.articleData?[indexPath.row].url)"
                            self.isSelected.toggle()
                            self.loadingView?.removeFromSuperview()
                            self.navigationController?.pushViewController(articleView, animated: true)
                        }
                    case .articleViewer:
                        DispatchQueue.main.async {
                            guard 
                                let articleView = storyboard.instantiateViewController(
                                    withIdentifier: "ArticleDetailViewController"
                                    )as? ArticleDetailViewController else { return }
                            articleView.articleData = data as AnyObject
                            self.isSelected.toggle()
                            self.loadingView?.removeFromSuperview()
                            self.navigationController?.pushViewController(articleView, animated: true)
                        }
                    }
                })
            }
        }
    }
}
