//
//  ScrapViewController.swift
//  tree
//
//  Created by Hyeontae on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import CoreData

class ScrapViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBarButton: UIButton!
    
    var testArray: [ScrappedArticle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        let testArticle = Article.init(
//            uri: "1",
//            lang: "en",
//            date: "2019-2-3",
//            time: "00:00",
//            sim: 02.07,
//            url: "hello.world",
//            title: "one",
//            body: "test\nbody",
//            source: Source.init(uri: "1", dataType: "2", title: "3"),
//            author: nil,
//            image: nil
//        )
//        let testArticle2 = Article.init(
//            uri: "1",
//            lang: "en",
//            date: "2019-2-3",
//            time: "00:00",
//            sim: 02.07,
//            url: "hello.world",
//            title: "two",
//            body: "test\nbody",
//            source: Source.init(uri: "1", dataType: "2", title: "3"),
//            author: nil,
//            image: nil
//        )
//        let testArticle3 = Article.init(
//            uri: "1",
//            lang: "en",
//            date: "2019-2-3",
//            time: "00:00",
//            sim: 02.07,
//            url: "hello.world",
//            title: "three",
//            body: "test\nbody",
//            source: Source.init(uri: "1", dataType: "2", title: "3"),
//            author: nil,
//            image: nil
//        )
        
        testArray = ScrapManager.fetchArticles()
//        testArray = ScrapManager.fetchArticles(.society)
        print(ScrapManager.unreadArticlesCount())
        print(ScrapManager.unreadArticlesCount(category: .arts))
        
//        ScrapManager.scrapArticle(article: testArticle, category: .society, imageData: nil)
//        ScrapManager.scrapArticle(article: testArticle2, category: .science, imageData: nil)
//        ScrapManager.scrapArticle(article: testArticle3, category: .arts, imageData: nil)
        
        tabBarButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    @objc func goNext(_ sender: UIButton) {
        guard let tempUIViewController =
            UIStoryboard.init(name: "ScrapFilter", bundle: nil)
                .instantiateViewController(withIdentifier: "ScrapFilterViewController")
                as? ScrapFilterViewController else {
            return
        }
        present(tempUIViewController,animated: true)
    }
    
}

extension ScrapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = testArray[indexPath.row].articleTitle
        return cell
    }
    
}
