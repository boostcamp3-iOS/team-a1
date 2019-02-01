//
//  TrandPageView.swift
//  tree
//
//  Created by ParkSungJoon on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class TrandPageView: UIView {

    @IBOutlet weak var tableView: UITableView!

    private let headerCellIdentifier = "TrandHeaderTableViewCell"
    private let listCellIdentifier = "TrandTableViewCell"
    private let dateHeaderCellIdentifier = "TrandDateHeaderCell"
    
    var googleTrendData: TrendDays?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerTableView()
        setTableView()
    }
    
    private func registerTableView() {
        let headerNib = UINib(nibName: headerCellIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: headerCellIdentifier)
        let listNib = UINib(nibName: listCellIdentifier, bundle: nil)
        tableView.register(listNib, forCellReuseIdentifier: listCellIdentifier)
        let dateHeaderNib = UINib(nibName: dateHeaderCellIdentifier, bundle: nil)
        tableView.register(dateHeaderNib, forCellReuseIdentifier: dateHeaderCellIdentifier)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIScreen.main.bounds.size.width,
            bottom: 0,
            right: 0
        )
    }
}

extension TrandPageView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard
            let sectionCount = googleTrendData?.trend.searchesByDays.count else {
                return 1
        }
        return sectionCount + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            guard
                let listBySection = googleTrendData?.trend.searchesByDays[section-1].keywordList else {
                    return 0
            }
            return listBySection.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        default:
            guard
                let headerCell = tableView.dequeueReusableCell(
                    withIdentifier: "TrandDateHeaderCell"
                    ) as? TrandDateHeaderCell else {
                        return UIView()
            }
            headerCell.backgroundColor = UIColor.white
            headerCell.dateLabel.text = googleTrendData?.trend.searchesByDays[section-1].formattedDate
            return headerCell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: headerCellIdentifier,
                for: indexPath
                ) as? TrandHeaderTableViewCell else {
                    return UITableViewCell()
            }
            return cell
        default:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: listCellIdentifier,
                    for: indexPath
                    ) as? TrandTableViewCell else {
                        return UITableViewCell()
            }
            let row = googleTrendData?.trend.searchesByDays[indexPath.section-1].keywordList[indexPath.row]
            cell.listView.titleLabel.text = row?.title.query
            cell.listView.rankLabel.text = "\(indexPath.row + 1)"
            cell.listView.subscriptLabel.text = row?.articles[0].title
            cell.listView.hitsLabel.text = row?.formattedTraffic
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
