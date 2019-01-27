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
    
    var articleImage: UIImage?
    private var initTouchPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setArticleImage()
        addPanGestureRecognizer()
    }
    
    private func setArticleImage() {
        imageView.image = articleImage
    }
    
    private func addPanGestureRecognizer() {
        let panGuestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissPanGesture))
        self.view.addGestureRecognizer(panGuestureRecognizer)
        panGuestureRecognizer.delegate = self
    }
    
    @IBAction func exitButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissPanGesture(_ sender: UIPanGestureRecognizer) {
        let touchPosition = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initTouchPosition = touchPosition
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPosition.y - initTouchPosition.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPosition.y - initTouchPosition.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPosition.y - initTouchPosition.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}

extension ArticleImageViewController: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
