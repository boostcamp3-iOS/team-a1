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
    @IBOutlet weak var scrapButton: UIButton!
    
    private var loadingView: LoadingView?
    private var article: ExtractArticle?
    private var articleURL: URL?
    private var isScrappedArticle: Bool = false
    var webData: Data?
    var articleURLString: String? {
        didSet {
            articleURL = makeURLWithString(urlString: articleURLString)
        }
    }
    var articleTitle: String?
    var press: String?
    
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
        if isScrappedArticle {
            navigationController?.isNavigationBarHidden.toggle()
        }
    }

    private func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func loadWebView() {
        if webData != nil {
            loadWebData()
            navigationController?.isNavigationBarHidden = true
            isScrappedArticle = true
            scrapButton.isHidden = true
        } else {
            loadWebDataWithURL()
        }
    }
    
    private func makeURLWithString(urlString: String?) -> URL? {
        guard let urlString = urlString else { return URL(string: "")}
        return URL(string: urlString)
    }
    
//    private func makeURLRequest(urlString: String) -> URLRequest? {
//        if let makeURL = URL(string: urlString) {
//            let urlRequest = URLRequest(url: makeURL)
//            return urlRequest
//        }
//        return nil
//    }
    
    private func loadWebDataWithURL() {
        guard let url = articleURL else { return }
        requestWebData(url) { [weak self] (responseData) in
            guard let self = self else { return }
            self.webData = responseData
            DispatchQueue.main.async {
                self.loadWebData()
            }
            
        }
    }
    
    private func loadWebData() {
        if let url = articleURL,
            let webData = webData {
            webView.load(
                webData,
                mimeType: "text/html",
                characterEncodingName: "utf-8",
                baseURL: url
            )
        }
    }
    
//    private func loadWebView() {
//        if let url = articleURLString, let requestURL = makeURLRequest(urlString: url) {
//            webView.load(requestURL)
//        }
//    }
    
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
    
    func requestWebData(_ url: URL, completion: @escaping (Data) -> Void ) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data: Data? , _ , error: Error? ) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("data error")
                return
            }
            completion(data)
        }
        task.resume()
    }
    
    
    @IBAction func backButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scrapButtonDidTap(_ sender: UIBarButtonItem) {
        guard let articleTitle = articleTitle,
            let press = press,
            let articleURLString = articleURLString,
            let webData = webData else {
                return }
        ScrapManager.scrapArticle(
            .web,
            articleStruct: WebViewArticleStruct(
                title: articleTitle,
                press: press,
                url: articleURLString,
                webData: webData
            )
        )
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
