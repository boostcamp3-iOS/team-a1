//
//  PresentationController.swift
//  tree
//
//  Created by Hyeontae on 28/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    fileprivate var dimmingView: UIView!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        guard let parentContainerView = containerView else { return CGRect() }
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: parentContainerView.bounds.size)
        frame.origin.y = parentContainerView.frame.height - 300
        return frame
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        dimmingViewSetting()
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
   
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize
        ) -> CGSize {
        return CGSize(width: parentSize.width, height: 375)
    }
}

private extension PresentationController {
    
    func dimmingViewSetting() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapAction(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func dimmingViewTapAction(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
