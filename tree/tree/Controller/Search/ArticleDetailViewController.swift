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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    private var floatingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        createFloatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeFloatingButton()
    }
    
    private func registerGestureRecognizer() {
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton.backgroundColor = .black
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.addTarget(self, action: #selector(translateButtonOnClick), for: .touchUpInside)
    }
    
    private func removeFloatingButton() {
      
    }
    
    @objc private func translateButtonOnClick() {
        
    }
    
    @objc private func imageTapped() {
        guard let articleImage = imageView.image else { return }
        guard let articleViewer = self.storyboard?.instantiateViewController(withIdentifier: "ArticleImageViewController") as? ArticleImageViewController else { return }
        articleViewer.articleImage = articleImage
        self.present(articleViewer, animated: true, completion: nil)
    }
}
