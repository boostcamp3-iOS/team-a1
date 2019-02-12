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
    
    private var initTouchPosition: CGPoint = CGPoint(x: 0, y: 0)
    var articleImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setArticleImage()
        addPanGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
    }

    private func setArticleImage() {
        imageView.image = articleImage
    }
    
    private func addPanGestureRecognizer() {
        let panGuestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissPanGesture))
        self.view.addGestureRecognizer(panGuestureRecognizer)
        panGuestureRecognizer.delegate = self
    }
    
    @objc private func dismissPanGesture(_ sender: UIPanGestureRecognizer) {
        let touchPosition = sender.location(in: self.view?.window)
        switch sender.state {
        case UIGestureRecognizer.State.began:
            initTouchPosition = touchPosition
        case UIGestureRecognizer.State.changed:
            if touchPosition.y - initTouchPosition.y > 0 {
                self.view.frame = CGRect(
                    x: 0, 
                    y: touchPosition.y - initTouchPosition.y,
                    width: self.view.frame.size.width, 
                    height: self.view.frame.size.height)
            }
        case UIGestureRecognizer.State.ended, UIGestureRecognizer.State.cancelled:
            if touchPosition.y - initTouchPosition.y > 200 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(
                        x: 0, 
                        y: 0, 
                        width: self.view.frame.size.width, 
                        height: self.view.frame.size.height)
                })
            }
        default:
            break
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
