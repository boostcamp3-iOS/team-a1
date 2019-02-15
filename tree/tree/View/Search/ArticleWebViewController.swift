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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }

    func setupDelegate() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

extension ArticleWebViewController: WKUIDelegate, WKNavigationDelegate {
    
}
