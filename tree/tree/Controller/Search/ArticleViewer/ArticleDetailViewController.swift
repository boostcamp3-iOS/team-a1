//
//  ArticleDetailViewController.swift
//  tree
//
//  Created by hyerikim on 22/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit
import NetworkFetcher

class ArticleDetailViewController: UIViewController, HUDViewProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: ArticleImage!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var scrapButton: UIButton!
    
    private var floatingButton = UIButton()
    private var isNavigationBarHidden = false
    var articleURLString: String?
    var articlePress: String?
    var articleData: AnyObject?
    var scrappedArticleDetail: ArticleBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestureRecognizer()
        setupScrapButton()
        if scrappedArticleDetail == nil {
            configure()
        } else {
            configureWithScrappedArticle()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        if navigationController?.isNavigationBarHidden == false {
            navigationController?.isNavigationBarHidden.toggle()
            isNavigationBarHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeFloatingButton()
        self.tabBarController?.tabBar.isHidden = false
        if isNavigationBarHidden {
            navigationController?.isNavigationBarHidden.toggle()
        }
    }
    
    private func getImageFromCache(from articleUrl: String?) {
        guard let imageUrl = articleUrl else { 
            imageView.isHidden = true
            return 
        }
        self.imageView.loadImageUrl(articleUrl: imageUrl)
    }
    
    private func registerGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupScrapButton() {
        var scrappped: Bool = {
            var tempFlag = false
            switch articleData {
            case is Article:
                // search
                guard let articleData = articleData as? Article else { fatalError() }
                ScrapManager.articleIsScrapped(.search, identifier: articleData.uri, completion: { (flag, _) in
                    tempFlag = flag
                })
            default:
//                guard let articleData = articleData as? ExtractArticle else { fatalError() }
                ScrapManager.articleIsScrapped(.webExtracted, identifier: articleURLString!, completion: { (flag, _) in
                    tempFlag = flag
                })
            }
            return tempFlag
        }()
        
        if scrappped {
            scrapButton.isHidden = true
        } else {
            scrapButton.addTarget(self, action: #selector(scrapButtonDidTapped), for: .touchUpInside)
        }
    }
    
    @objc private func scrapButtonDidTapped(_ sender: UIButton) {
        switch articleData {
        case is ExtractArticle:
            guard let article = articleData as? ExtractArticle else { return }
            var detail: String {
                if article.body.count == 0 {
                    return article.description
                } else {
                    return article.body
                }
            }
            var imageData: Data? {
                if let uiImage = imageView.image {
                    return UIImage.pngData(uiImage)()
                } else {
                    return nil
                }
            }
            guard let articleURLString = articleURLString,
                let press = articlePress else {
                    return
            }
            
            let articleStruct = WebExtractedArticleStruct(
                title: article.title,
                detail: detail,
                press: press,
                description: article.description,
                url: articleURLString,
                imageData: imageData
            )
            ScrapManager.scrapArticle(.webExtracted, articleStruct: articleStruct)
        default:
            guard let article = articleData as? Article else { return }
            var imageData: Data? {
                if let uiImage = imageView.image {
                    return UIImage.pngData(uiImage)()
                } else {
                    return nil
                }
            }
            let articleStruct = SearchedArticleStruct(articleData: article, imageData: imageData)
            ScrapManager.scrapArticle(.search, articleStruct: articleStruct)
        }
        hud(inView: view, text: "Scrapped!")
        scrapButton.isHidden = true
    }
    
    private func configure() {
        switch articleData {
        case is ExtractArticle:
            let articleDetail = self.articleData as? ExtractArticle
            titleLabel.text = articleDetail?.title
            contentLabel.text = articleDetail?.body
            if articleDetail?.body.count == 0 {
                contentLabel.text = articleDetail?.description
            }
            getImageFromCache(from: articleDetail?.image ?? nil)
        case is Article:
            let articleDetail = self.articleData as? Article
            titleLabel.text = articleDetail?.title
            dateLabel.text = articleDetail?.date
            contentLabel.text = articleDetail?.body
            getImageFromCache(from: articleDetail?.image ?? nil)
            if articleDetail?.author?.isEmpty == false,
                let author = articleDetail?.author?.first?.name {
                    self.authorLabel.text = author
            }
        default:
            print("nothing")
        }
    }
    
    private func configureWithScrappedArticle() {
        guard let articleData = scrappedArticleDetail else { return }
        titleLabel.text = articleData.title
        if let author = articleData.author {
            authorLabel.text = author
        }
        switch articleData.articleTypeEnum {
        case .webExtracted:
            guard let detail = articleData.webExtracted else { return }
            contentLabel.text = articleData.webExtracted?.contents
            if let imageData = detail.imageData {
                imageView.image(from: imageData as Data)
            }
        case .search:
            guard let detail = articleData.searched else { return }
            dateLabel.text = detail.articleDate
            contentLabel.text = articleData.searched?.contents
            if let imageData = detail.imageData {
                imageView.image(from: imageData as Data)
            }
        default:
            fatalError("exception because of web case")
        }
    }
    
    private func createFloatingButton() {
        floatingButton.backgroundColor = .black
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.addTarget(self, action: #selector(floatingButtonClick), for: .touchUpInside)
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.floatingButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.floatingButton.trailingAnchor, constant: 25),
                    keyWindow.bottomAnchor.constraint(equalTo: self.floatingButton.bottomAnchor, constant: 40),
                    self.floatingButton.widthAnchor.constraint(equalToConstant: 50),
                    self.floatingButton.heightAnchor.constraint(equalToConstant: 50)])
            }
        }
    }
    
    private func removeFloatingButton() {
        if floatingButton.superview != nil {
            DispatchQueue.main.async {
                self.floatingButton.removeFromSuperview()
            }
        }
    }

    @objc private func floatingButtonClick() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.floatingButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: { 
                self.floatingButton.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc private func imageTapped() {
        guard let articleImage = imageView.image else { return }
        guard let articleViewer = self.storyboard?.instantiateViewController(withIdentifier: "ArticleImageViewController") as? ArticleImageViewController else { return }
        articleViewer.articleImage = articleImage
        self.present(articleViewer, animated: false, completion: nil)
    }
    
    @IBAction func backButtonItemDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
