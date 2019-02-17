//
//  IntentViewController.swift
//  TrendUI
//
//  Created by ParkSungJoon on 17/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import IntentsUI

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let localizedLanguage = "ko"
    private let cellIdentifier = "TrendIntentCell"
    private var trendData: [TrendingSearch]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.hideActivityIndicator()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: UIScreen.main.bounds.width,
            bottom: 0,
            right: 0
        )
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.tableHeaderView = UIView.init(frame: CGRect.zero)
    }
        
    // MARK: - INUIHostedViewControlling
    // Intent UI에서 제공하는 기본 제공 메소드 입니다.
    func configureView(
        for parameters: Set<INParameter>,
        of interaction: INInteraction,
        interactiveBehavior: INUIInteractiveBehavior,
        context: INUIHostedViewContext,
        completion: @escaping (Bool, Set<INParameter>, CGSize
    ) -> Void) {
        guard
            let intent = interaction.intent as? TrendIntent,
            let country = intent.country else { return }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        APIManager.fetchDailyTrends(hl: localizedLanguage, geo: country) { (result) in
            switch result {
            case .success(let trendData):
                guard let recentDay = trendData.trend.searchesByDays.first else { return }
                self.trendData = recentDay.keywordList
                completion(true, parameters, self.desiredSize)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var desiredSize: CGSize {
        var siriResponseViewSize = self.extensionContext!.hostedViewMaximumAllowedSize
        guard let trendData = trendData else { return siriResponseViewSize }
        siriResponseViewSize.height = CGFloat(trendData.count) * 44  + 5
        return siriResponseViewSize
    }
    
    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}

extension IntentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trendData = trendData {
            return trendData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: cellIdentifier,
                for: indexPath
            ) as? TrendIntentCell else { fatalError() }
        guard let trendData = trendData else { fatalError() }
        cell.rankLabel.text = "\(indexPath.row + 1)"
        cell.keywordLabel.text = trendData[indexPath.row].title.query
        return cell
    }
}
