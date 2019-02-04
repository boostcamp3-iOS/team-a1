//
//  LiveViewController.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    private let pageNibName = "TrendPageView"
    private var livePagerPages: [TrendPageView] = []
    private var googleTrendData: TrendDays? {
        didSet {
            DispatchQueue.main.async {
                self.setTrandPages()
            }
        }
    }
    private var countryName: String = Country.usa.info.name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWithServer(Country.usa.info.code)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveCountryInfo(_:)),
            name: .observeCountryChanging,
            object: nil
        )
    }
    
    @objc func receiveCountryInfo(_ notification: Notification) {
        guard let countryInfo = notification.userInfo as? [String: String] else { return }
        guard let countryCode = countryInfo["code"] else { return }
        guard let countryName = countryInfo["name"] else { return }
        networkWithServer(countryCode)
        self.countryName = countryName
    }
    
    private func setTrandPages() {
        livePagerPages = createPages()
        setPageScrollView(pages: livePagerPages)
        pageControl.numberOfPages = livePagerPages.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    private func networkWithServer(_ geo: String) {
        APIManager.getDailyTrends(hl: "ko", geo: geo) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let trandData):
                self.googleTrendData = trandData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createPages() -> [TrendPageView] {
        guard let pageByDays: TrendPageView = Bundle.main.loadNibNamed(
            pageNibName,
            owner: self,
            options: nil
            )?.first as? TrendPageView else {
                return []
        }
        pageByDays.daysKeywordChart = HeaderCellContent(
            title: "일별 급상승 검색어",
            country: countryName
        )
        pageByDays.googleTrendData = googleTrendData
        guard let pageByRealTime: TrendPageView = Bundle.main.loadNibNamed(
            pageNibName,
            owner: self,
            options: nil
            )?.first as? TrendPageView else {
                return []
        }
        return [pageByDays, pageByRealTime]
    }
    
    private func setPageScrollView(pages: [TrendPageView]) {
        scrollView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: view.frame.height
        )
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(pages.count),
            height: view.frame.height
        )
        scrollView.isPagingEnabled = true
        for index in 0 ..< pages.count {
            pages[index].frame = CGRect(
                x: view.frame.width * CGFloat(index),
                y: 0,
                width: view.frame.width,
                height: view.frame.height
            )
            scrollView.addSubview(pages[index])
        }
    }
}
