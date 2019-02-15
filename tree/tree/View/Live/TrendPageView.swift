//
//  TrandPageView.swift
//  tree
//
//  Created by ParkSungJoon on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

protocol PushViewControllerDelegate: class {
    func pushViewControllerWhenDidSelectRow(with rowData: TrendingSearch)
}

class TrendPageView: UIView, ExpandableHeaderDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    private let headerCellIdentifier = "TrendHeaderCell"
    private let listCellIdentifier = "TrendListCell"
    private let listHeaderCellIdentifier = "TrendListHeaderCell"
    weak var delegate: PushViewControllerDelegate?
    var googleTrendData: TrendDays? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var daysKeywordChart: HeaderCellContent?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerXIB()
        tableViewSetup()
    }
    
    private func registerXIB() {
        let headerNib = UINib(nibName: headerCellIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: headerCellIdentifier)
        let listNib = UINib(nibName: listCellIdentifier, bundle: nil)
        tableView.register(listNib, forCellReuseIdentifier: listCellIdentifier)
        let dateHeaderNib = UINib(nibName: listHeaderCellIdentifier, bundle: nil)
        tableView.register(dateHeaderNib, forCellReuseIdentifier: listHeaderCellIdentifier)
    }
    
    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIScreen.main.bounds.size.width,
            bottom: 0,
            right: 0
        )
    }
    
    func tappedCountryButton(_ country: String) {
        guard let headerData = daysKeywordChart else { return }
        headerData.expanded.toggle()
        headerData.country = country
        let headerIndexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [headerIndexPath], with: .automatic)
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
                let listBySection = googleTrendData?.trend
                    .searchesByDays[section-1]
                    .keywordList else {
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
            headerCell.headerLabel.text = googleTrendData?.trend.searchesByDays[section-1]
                                         .formattedDate
            return headerCell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return 50
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
            guard let headerData = daysKeywordChart else {
                return UITableViewCell()
            }
            cell.expandableHeaderDelegate = self
            cell.configure(by: headerData)
            return cell
        default:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: listCellIdentifier,
                    for: indexPath
                    ) as? TrendListCell else {
                        return UITableViewCell()
            }
            guard let keywordData = googleTrendData?.trend else {
                return UITableViewCell()
            }
            let section = indexPath.section - 1
            let row = indexPath.row
            cell.configure(by: keywordData, with: section, row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: break
        default:
            let animation = AnimationFactory.makeMoveUpWithFade(
                rowHeight: cell.frame.height,
                duration: 0.3,
                delayFactor: 0.05
            )
            let animator = Animator(animation: animation)
            animator.animate(to: cell, at: indexPath, in: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let headerData = daysKeywordChart else { return }
            headerData.expanded.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            guard
                let keywordRowData = googleTrendData?.trend
                    .searchesByDays[indexPath.section - 1]
                    .keywordList[indexPath.row] else {
                    return
            }
            delegate?.pushViewControllerWhenDidSelectRow(with: keywordRowData)
        }
    }
}
