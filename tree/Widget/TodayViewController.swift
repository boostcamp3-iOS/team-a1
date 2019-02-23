//
//  TodayViewController.swift
//  Widget
//
//  Created by ParkSungJoon on 23/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NotificationCenter
import NetworkFetcher

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var widgetHeaderView: UIView!
    @IBOutlet weak var widgetTitleLabel: UILabel!
    @IBOutlet weak var widgetDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var todayTrendData: TrendingSearchesDay? {
        didSet {
            DispatchQueue.main.async {
                self.widgetDateLabel.text = self.todayTrendData?.formattedDate
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    private let cellIdentifier = "RankKeywordCell"
    private let localizedLanguage = LocalizedLanguages.korean.rawValue
    private let country = Country.kor.info.code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer()
        setupTableView()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTrendKeywordData()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        fetchTrendKeywordData()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        guard let todayTrendCount = todayTrendData?.keywordList.count else { return }
        switch activeDisplayMode {
        case .expanded:
            self.preferredContentSize = CGSize(
                width: self.view.frame.size.width,
                height: CGFloat(todayTrendCount) * self.tableView.estimatedRowHeight + self.widgetHeaderView.frame.size.height
            )
        case .compact:
            self.preferredContentSize = maxSize
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.tableHeaderView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func fetchTrendKeywordData() {
        activityIndicator.startAnimating()
        BoosterManager.fetchDailyTrends(hl: localizedLanguage, geo: country) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let trendData):
                guard let todayTrendData = trendData.trend.searchesByDays.first else { return }
                self.todayTrendData = todayTrendData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedWidget(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func didTappedWidget(sender: UITapGestureRecognizer) {
        guard let url = URL(string: "tree://") else { return }
        extensionContext?.open(url, completionHandler: nil)
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let todayTrendData = todayTrendData {
            return todayTrendData.keywordList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier,
            for: indexPath
        ) as? RankKeywordCell else { fatalError() }
        guard let rowData = todayTrendData?.keywordList[indexPath.row] else { fatalError() }
        let rank = indexPath.row + 1
        cell.configure(by: rowData, rank)
        return cell
    }
}
