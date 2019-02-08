//
//  KeywordDetailViewController.swift
//  tree
//
//  Created by ParkSungJoon on 07/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class KeywordDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var keywordData: TrendingSearch? {
        didSet {
            let date = calculateDateRange()
            guard let keyword = keywordData?.title.query else { return }
            getGraphData(to: keyword, date.start, date.end)
        }
    }
    var graphData: Graph?
    
    private let oneDay = TimeIntervalTypes.oneDay.value
    private let oneMonth = TimeIntervalTypes.oneMonth.value
    private let timeUnit = TimeUnitTypes.week.value
    private let graphCellIdentifier = "KeywordDetailGraphCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        tableView.reloadData()
    }
    
    private func setTableView() {
        let nibName = UINib(nibName: graphCellIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: graphCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func calculateDateRange() -> (start: String, end: String) {
        let todayDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let endDate = Date(timeInterval: -oneDay, since: todayDate)
        let startDate = Date(timeInterval: -oneMonth, since: todayDate)
        return (formatter.string(from: startDate), formatter.string(from: endDate))
    }
    
    private func getGraphData(to keyword: String, _ startDate: String, _ endDate: String) {
        let keywordGroups: [[String: Any]] = [[
            "groupName": keyword,
            "keywords": [keyword]
            ]]
        APIManager.getGraphData(
            startDate: startDate,
            endDate: endDate,
            timeUnit: timeUnit,
            keywordGroups: keywordGroups
        ) { (result) in
            switch result {
            case .success(let graphData):
                self.graphData = graphData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension KeywordDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: graphCellIdentifier,
                for: indexPath
            ) as? KeywordDetailGraphCell else {
                return UITableViewCell()
        }
        cell.graphData = graphData?.results[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
