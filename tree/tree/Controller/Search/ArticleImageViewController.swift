//
//  ArticleImageViewController.swift
//  tree
//
//  Created by hyerikim on 25/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var myImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerDelegate()
        setArticleImage()
    }
    
    private func setArticleImage() {
        imageView.image = myImage
    }
    
    private func registerDelegate() {
        scrollView.delegate = self
    }
    
    @IBAction func exitButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ArticleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
