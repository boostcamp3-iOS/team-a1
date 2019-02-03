//
//  TrandPageView.swift
//  tree
//
//  Created by ParkSungJoon on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class TrendPageView: UIView {

    @IBOutlet weak var tableView: UITableView!

    private let headerCellIdentifier = "TrendHeaderCell"
    private let listCellIdentifier = "TrendListCell"
    private let listHeaderCellIdentifier = "TrendListHeaderCell"
    
    var googleTrendData: TrendDays?
    var daysKeywordChart = HeaderCellContent(title: "일별 급상승 검색어", country: "미국")
    
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
        let dateHeaderNib = UINib(nibName: listHeaderCellIdentifier, bundle: nil)
        tableView.register(dateHeaderNib, forCellReuseIdentifier: listHeaderCellIdentifier)
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

extension TrendPageView: UITableViewDelegate, UITableViewDataSource {
    
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
                    withIdentifier: listHeaderCellIdentifier
                    ) as? TrendListHeaderCell else {
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
                ) as? TrendHeaderCell else {
                    return UITableViewCell()
            }
            cell.configure(by: daysKeywordChart)
            cell.delegate = self
            return cell
        default:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: listCellIdentifier,
                    for: indexPath
                    ) as? TrendListCell else {
                        return UITableViewCell()
            }
            let row = googleTrendData?.trend.searchesByDays[indexPath.section-1].keywordList[indexPath.row]
            cell.titleLabel.text = row?.title.query
            cell.rankLabel.text = "\(indexPath.row + 1)"
            cell.subscriptLabel.text = row?.articles[0].title
            cell.hitsLabel.text = row?.formattedTraffic
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        default:
            let animation = AnimationFactory.makeMoveUpWithFade(
                rowHeight: cell.frame.height,
                duration: 0.2,
                delayFactor: 0.03
            )
            let animator = Animator(animation: animation)
            animator.animate(to: cell, at: indexPath, in: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            daysKeywordChart.expanded = !daysKeywordChart.expanded
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

extension TrendPageView: SelectedDelegate {
    func passSelectedCountryInfo(_ name: String, _ code: String) {
        print(name, code)
        daysKeywordChart.expanded = !daysKeywordChart.expanded
        daysKeywordChart.country = name
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
