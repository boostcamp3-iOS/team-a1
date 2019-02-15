//
//  ArticleDetailViewController.swift
//  tree
//
//  Created by hyerikim on 22/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: ArticleImage!
    @IBOutlet weak var contentLabel: UILabel!
    
    private lazy var papagoButton = UIButton(type: .custom)
    private var floatingButton = UIButton()
    private var floatingCheckAnimation: Bool = true 
    var articleDetail: Article?
    var scrappedArticleDetail: ScrappedArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestureRecognizer()
        if scrappedArticleDetail == nil {
            setArticleData()
        } else {
            setScrappedArticleData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        createFloatingButton()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeFloatingButton()
        self.tabBarController?.tabBar.isHidden = false
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
    
    private func setArticleData() {
        titleLabel.text = articleDetail?.title
        dateLabel.text = articleDetail?.date
        contentLabel.text = articleDetail?.body
        getImageFromCache(from: articleDetail?.image ?? nil)
        if articleDetail?.author?.isEmpty == false {
            if let author = articleDetail?.author?[0].name {
                self.authorLabel.text = author
            }
        }
    }
    
    private func setScrappedArticleData() {
        guard let articleData = scrappedArticleDetail else { return}
        if let title = articleData.articleTitle,
            let date = articleData.articleDate,
            let content = articleData.articleDescription {
            titleLabel.text = title
            dateLabel.text = date
            contentLabel.text = content
        }
        if let author = articleData.articleAuthor {
            authorLabel.text = author
        }
        if let image = articleData.image {
            imageView.image(from: image as Data)
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
        if floatingButton.superview != nil || papagoButton.superview != nil {
            DispatchQueue.main.async {
                self.floatingButton.removeFromSuperview()
                self.papagoButton.removeFromSuperview()
            }
        }
    }

    @objc private func floatingButtonClick() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.floatingButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            if self.floatingCheckAnimation {
                UIView.animate(withDuration: 0.2, animations: { 
                    self.floatingButton.transform = CGAffineTransform.identity
                    self.papagoButton.backgroundColor = .black
                    self.papagoButton.translatesAutoresizingMaskIntoConstraints = false
                    self.papagoButton.addTarget(self, action: #selector(self.papagoTranslate), for: .touchUpInside)
                    DispatchQueue.main.async {
                        if let keyWindow = UIApplication.shared.keyWindow {
                            keyWindow.addSubview(self.papagoButton)
                            NSLayoutConstraint.activate([
                                keyWindow.trailingAnchor.constraint(equalTo: self.papagoButton.trailingAnchor, constant: 25),
                                self.floatingButton.topAnchor.constraint(equalTo: self.papagoButton.bottomAnchor, constant: 16),
                                self.papagoButton.widthAnchor.constraint(equalToConstant: 30),
                                self.papagoButton.heightAnchor.constraint(equalToConstant: 30)])
                        }
                        self.papagoButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }  
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: { 
                    self.floatingButton.transform = CGAffineTransform.identity
                })
                self.papagoButton.removeFromSuperview()
            }
            self.floatingCheckAnimation.toggle()
        }
    }
    
    @objc private func imageTapped() {
        guard let articleImage = imageView.image else { return }
        guard let articleViewer = self.storyboard?.instantiateViewController(withIdentifier: "ArticleImageViewController") as? ArticleImageViewController else { return }
        articleViewer.articleImage = articleImage
        self.present(articleViewer, animated: false, completion: nil)
    }
    
    @objc private func papagoTranslate() {
        
    }
    
}
