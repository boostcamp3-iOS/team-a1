//
//  ArticleWebViewController.swift
//  tree
//
//  Created by hyeri kim on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    private var loadingView: LoadingView?
    private var articleURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        requestURL(url: articleURL)
    }

    private func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func requestURL(url: String) {
        if let makeUrl = URL(string: url) {
            let request = URLRequest(url: makeUrl)
            webView.load(request)
        }
    }
    
    private func setLoadingView() {
        let loadingViewFrame = CGRect(
            x: 0,
            y: 0, 
            width: 100,
            height: 100
        )
        loadingView = LoadingView(frame: loadingViewFrame)
        guard let loadView = loadingView else { return } 
        loadView.center = self.view.center
        self.view.addSubview(loadView)        
    }
}

extension ArticleWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        setLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingView?.removeFromSuperview()
    }
}
