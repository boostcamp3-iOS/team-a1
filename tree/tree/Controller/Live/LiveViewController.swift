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

    private var pages: [TrandPageView] = []
    private var googleTrendData: TrendDays? {
        didSet {
            DispatchQueue.main.async {
                self.setTrandPages()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWithServer()
    }
    
    private func setTrandPages() {
        pages = createPages()
        setPageScrollView(pages: pages)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    private func networkWithServer() {
        APIManager.getDailyTrends(hl: "ko", geo: "US") { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let trandData):
                self.googleTrendData = trandData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createPages() -> [TrandPageView] {
        guard let page1: TrandPageView = Bundle.main.loadNibNamed(
            "TrandPageView",
            owner: self,
            options: nil
            )?.first as? TrandPageView else {
                return []
        }
        page1.googleTrendData = googleTrendData
        guard let page2: TrandPageView = Bundle.main.loadNibNamed(
            "TrandPageView",
            owner: self,
            options: nil
            )?.first as? TrandPageView else {
                return []
        }
        return [page1, page2]
    }
    
    private func setPageScrollView(pages : [TrandPageView]) {
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
