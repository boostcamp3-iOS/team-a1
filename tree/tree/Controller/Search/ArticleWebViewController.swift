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

    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    
    private var loadingView: LoadingView?
    private var article: ExtractArticle?
    var articleURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        fetctExtractArticle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func fetctExtractArticle() {
        APIManager.extractArticle(url: articleURL) { (result) in
            switch result {
            case .success(let data):
                self.article = data
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func requestURL(urlString: String) {
        if let makeUrl = URL(string: urlString) {
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
    
    @IBAction func backButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
