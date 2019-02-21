//
//  ArticleWebViewController.swift
//  tree
//
//  Created by hyeri kim on 15/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import WebKit
import NetworkFetcher

class ArticleWebViewController: UIViewController {

    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    
    private var loadingView: LoadingView?
    private var article: ExtractArticle?
    var articleURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func makeURLRequest(urlString: String) -> URLRequest? {
        if let makeURL = URL(string: urlString) {
            let urlRequest = URLRequest(url: makeURL)
            return urlRequest
        }
        return nil
    }
    
    private func loadWebView() {
        if let url = articleURL, let requestURL = makeURLRequest(urlString: url) {
            webView.load(requestURL)
        }
    }
    
    private func setupLoadingView() {
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
    
    @IBAction func backButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scrapButtonDidTap(_ sender: UIBarButtonItem) {
        //webView scrap
    }
}

extension ArticleWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        setupLoadingView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingView?.removeFromSuperview()
    }
}
