//
//  SplashcircleViewController.swift
//  tree
//
//  Created by ParkSungJoon on 18/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var rightBottomCircleView: UIView! {
        didSet {
            rightBottomCircleView.roundCorners(
                layer: rightBottomCircleView.layer,
                radius: rightBottomCircleView.frame.width / 2
            )
            rightBottomCircleView.applyGradient(
                colours: rightBottomGradientColors,
                startPoint: CGPoint(x: 1.0, y: 0.0),
                endPoint: CGPoint(x: 0.0, y: 1.0)
            )
        }
    }
    @IBOutlet weak var leftBottomCircleView: UIView! {
        didSet {
            leftBottomCircleView.roundCorners(
                layer: leftBottomCircleView.layer,
                radius: leftBottomCircleView.frame.width / 2
            )
            leftBottomCircleView.applyGradient(
                colours: leftBottomGradientColors,
                startPoint: CGPoint(x: 0.0, y: 0.0),
                endPoint: CGPoint(x: 1.0, y: 1.0)
            )
        }
    }
    @IBOutlet weak var leftTopCircleView: UIView! {
        didSet {
            leftTopCircleView.roundCorners(
                layer: leftTopCircleView.layer,
                radius: leftTopCircleView.frame.width / 2
            )
            leftTopCircleView.applyGradient(
                colours: leftTopGradientColors,
                startPoint: CGPoint(x: 0.0, y: 0.0),
                endPoint: CGPoint(x: 1.0, y: 1.1)
            )
        }
    }
    @IBOutlet weak var rightTopCircleView: UIView! {
        didSet {
            rightTopCircleView.roundCorners(
                layer: rightTopCircleView.layer,
                radius: rightTopCircleView.frame.width / 2
            )
            rightTopCircleView.applyGradient(
                colours: rightTopGradientColors,
                startPoint: CGPoint(x: 1.0, y: 0.0),
                endPoint: CGPoint(x: 0.0, y: 1.0)
            )
        }
    }
    @IBOutlet weak var appNameLabel: UILabel!
    
    private let rightBottomGradientColors = [UIColor.orange, UIColor.purpleBlue]
    private let leftBottomGradientColors = [UIColor.skyBlue, UIColor.deepBlue]
    private let leftTopGradientColors = [UIColor.brightRed, UIColor.brightYellow]
    private let rightTopGradientColors = [UIColor.lightPink, UIColor.brightPurple]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateViewToScaleUp(view: rightBottomCircleView, delay: 0.0)
        animateViewToScaleUp(view: leftBottomCircleView, delay: 0.1)
        animateViewToScaleUp(view: leftTopCircleView, delay: 0.2)
        animateViewToScaleUp(view: rightTopCircleView, delay: 0.3)
        fadeIn(label: appNameLabel, duration: 0.5, delay: 1.0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.changeRootViewController()
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {     
        return .lightContent
    }
    
    private func changeRootViewController() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = main.instantiateViewController(
            withIdentifier: "ScrapTabBarController"
        ) as? UITabBarController else { return }
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
    }
    
    private func animateViewToScaleUp(view: UIView, delay: TimeInterval) {
        UIView.animate(withDuration: 0.4, delay: delay, options: .curveEaseIn, animations: {
            view.alpha = 0.0
            view.transform = CGAffineTransform(scaleX: 0.00, y: 0.00)
        }) { _ in
            self.scaleUp(view: view)
        }
    }
    
    private func fadeIn(
        label: UILabel,
        duration: TimeInterval,
        delay: TimeInterval,
        completion: @escaping () -> Void) {
        label.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            label.alpha = 1.0
        }) { _ in
            completion()
        }
    }
    
    private func scaleUp(view: UIView) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseIn, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        })
    }
}
