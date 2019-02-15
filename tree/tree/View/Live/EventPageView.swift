//
//  EventPageView.swift
//  tree
//
//  Created by ParkSungJoon on 12/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class EventPageView: UIView {

    @IBOutlet var tableView: UITableView!
    
    var recentEventData: [CategoryEvents]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let headerCellIdentifier = "EventHeaderCell"
    private let feedCellIdentifier = "EventFeedCell"
    private let listHeaderCellIdentifier = "TrendListHeaderCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerXIB()
        setupTableView()
    }
    
    private func registerXIB() {
        let headerNib = UINib(nibName: headerCellIdentifier, bundle: nil)
        tableView.register(headerNib, forCellReuseIdentifier: headerCellIdentifier)
        let feedNib = UINib(nibName: feedCellIdentifier, bundle: nil)
        tableView.register(feedNib, forCellReuseIdentifier: feedCellIdentifier)
        let sectionHeaderNib = UINib(nibName: listHeaderCellIdentifier, bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: listHeaderCellIdentifier)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIScreen.main.bounds.width,
            bottom: 0,
            right: 0
        )
    }
}

extension EventPageView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard
            let sectionCount = recentEventData?.count else {
                return 1
        }
        return sectionCount + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            guard let eventList = recentEventData else { return 0 }
            return eventList[section - 1].events.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            guard let recentEventData = recentEventData else { return UIView() }
            headerCell.backgroundColor = UIColor.white
            headerCell.headerLabel.text = recentEventData[section - 1].category
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
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: headerCellIdentifier,
                    for: indexPath
                ) as? EventHeaderCell else {
                    return UITableViewCell()
            }
            return cell
        default:
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: feedCellIdentifier,
                    for: indexPath
                ) as? EventFeedCell else {
                    return UITableViewCell()
            }
            guard
                let resultInfoData = recentEventData else {
                    return UITableViewCell()
            }
            let resultInfoRowData = resultInfoData[indexPath.section - 1].events[indexPath.row]
            cell.configure(by: resultInfoRowData)
            return cell
        }
    }
}
