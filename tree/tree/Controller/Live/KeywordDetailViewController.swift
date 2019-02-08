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
            guard let keyword = keywordData?.title.query else { return }
            loadGraphData(to: keyword, startDate, endDate)
        }
    }
    var graphData: Graph?
    
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
    
    private let timeUnit = TimeUnitTypes.week.value
    private let graphCellIdentifier = "KeywordDetailGraphCell"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    private func setTableView() {
        let nibName = UINib(nibName: graphCellIdentifier, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: graphCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadGraphData(to keyword: String, _ startDate: String, _ endDate: String) {
        let keywordGroups: [[String: Any]] = [[
            "groupName": keyword,
            "keywords": [keyword]
            ]]
        APIManager.graphData(
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
