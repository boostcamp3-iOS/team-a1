//
//  LiveViewController.swift
//  tree
//
//  Created by ParkSungJoon on 29/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import Intents

class LiveViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    private var livePagerPages: [UIView] = []
    private var googleTrendData: TrendDays? {
        didSet {
            guard let trendPage = livePagerPages.first as? TrendPageView else { return }
            trendPage.googleTrendData = googleTrendData
        }
    }
    private var recentEventData: [CategoryEvents]? {
        didSet {
            guard let eventPage = livePagerPages.last as? EventPageView else { return }
            eventPage.recentEventData = recentEventData
        }
    }
    private var countryName: String = Country.usa.info.name
    private var loadingView: LoadingView?
    private let localizedLanguage = LocalizedLanguages.korean.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        setupTrendPages()
        fetchDailyTrends(from: Country.usa.info.code)
        fetchTopRecentEvents(with: 1)
        addNotificationObserver()
    }
    
    @objc func receiveCountryInfo(_ notification: Notification) {
        guard let countryInfo = notification.userInfo as? [String: String] else { return }
        guard
            let countryCode = countryInfo["code"],
            let countryName = countryInfo["name"]  else {
                return
        }
        fetchDailyTrends(from: countryCode)
        self.countryName = countryName
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveCountryInfo(_:)),
            name: .observeCountryChanging,
            object: nil
        )
    }
    
    // MARK: - Intent Setting
    private func donate(country: String) {
        let intent = TrendIntent()
        intent.suggestedInvocationPhrase = "\(countryName) 급상승 검색어"
        intent.country = country // 급상승 검색어를 불러올 국가를 선택합니다.
        
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    print("Interaction donation failed: \(error.description)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
    
    private func setupTrendPages() {
        livePagerPages = createPages()
        addPagesToScrollView(pages: livePagerPages)
        pageControl.numberOfPages = livePagerPages.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    // MARK: Siri 권한 호출
    private func requestSiriAuthorization(_ geo: String) {
        print(geo)
        INPreferences.requestSiriAuthorization({ (status) in
            switch status {
            case .authorized:
                self.donate(country: geo)
            default:
                print("권한이 거부됨.")
                break
            }
        })
    }
    
    private func fetchDailyTrends(from geo: String) {
        guard let pageByDays = livePagerPages.first else { return }
        setupLoadingView(pageByDays)
        APIManager.fetchDailyTrends(hl: localizedLanguage, geo: geo) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let trendData):
                self.requestSiriAuthorization(geo)
                DispatchQueue.main.async {
                    self.loadingView?.removeFromSuperview()
                }
                self.googleTrendData = trendData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /* API 호출을 Page nation 방식으로 변화될 여지가 있어 pageNumber 파라미터를 남겨두었습니다.
     현재는 한 페이지에 데이터 50개를 받아옵니다.
     */
    private func fetchTopRecentEvents(with pageNumber: Int) {
        APIManager.fetchRecentEvents(
            pageNumber: pageNumber
        ) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let eventData):
                self.recentEventData = self.resortByCategory(from: eventData.events.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /* 최신순 형태로 정렬되어 들어오는 데이터를 Category별로 분류하기 위한 알고리즘입니다.
     Category uri를 / 단위로 잘라내 해당 Category 이름을 뽑아 내었고, 아래 형식과 같습니다.
     [
        {
            "category": "Sports",
            "event": Issue Data (ResultInfo)
        },
        {
            "category": "Arts",
            "event": Issue Data (ResultInfo)
        }
    ]
     */
    private func resortByCategory(from events: [ResultInfo]) -> [CategoryEvents] {
        var categoryDic: [String: [ResultInfo]] = [:]
        let categoryETC = ArticleCategory.etc.stringValue.uppercased()
        for event in events {
            if let category = event.categories.first?.uri.components(separatedBy: "/")[1] {
                if var categoryKey = categoryDic[category] {
                    categoryKey.append(event)
                    categoryDic.updateValue(categoryKey, forKey: category)
                } else {
                    categoryDic.updateValue([event], forKey: category)
                }
            } else {
                if var etcKey = categoryDic[categoryETC] {
                    etcKey.append(event)
                    categoryDic.updateValue(etcKey, forKey: categoryETC)
                } else {
                    categoryDic.updateValue([event], forKey: categoryETC)
                }
            }
        }
        var categoryEvents = [CategoryEvents]()
        for (key, value) in categoryDic {
            categoryEvents.append(CategoryEvents(category: key, events: value))
        }
        return categoryEvents.sorted { $0.category < $1.category }
    }
    
    private func createPages() -> [UIView] {
        guard let pageByDays: TrendPageView = Bundle.main.loadNibNamed(
            NibName.trendPage,
            owner: self,
            options: nil
        )?.first as? TrendPageView else {
                return []
        }
        pageByDays.daysKeywordChart = HeaderCellContent(
            title: "급상승 검색어",
            country: countryName
        )
        pageByDays.pushViewControllerDelegate = self
        
        guard let pageByEvent: EventPageView = Bundle.main.loadNibNamed(
            NibName.eventPage,
            owner: self,
            options: nil
        )?.first as? EventPageView else {
            return []
        }
        return [pageByDays, pageByEvent]
    }
    
    private func addPagesToScrollView(pages: [UIView]) {
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
    
    private func setupLoadingView(_ page: UIView) {
        let loadingViewFrame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 100
        )
        loadingView = LoadingView(frame: loadingViewFrame)
        guard let loadView = loadingView else { return }
        loadView.center = self.view.center
        page.addSubview(loadView)
    }
}

extension LiveViewController: PushViewControllerDelegate {
    func didSelectRow(with rowData: TrendingSearch) {
        guard
            let detailViewController = self.storyboard?.instantiateViewController(
                withIdentifier: "KeywordDetailViewController"
                ) as? KeywordDetailViewController else {
                    return
        }
        detailViewController.keywordData = rowData
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
