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
        animateObjectToScaleUp(rightBottomCircleView, 0.0)
        animateObjectToScaleUp(leftBottomCircleView, 0.1)
        animateObjectToScaleUp(leftTopCircleView, 0.2)
        animateObjectToScaleUp(rightTopCircleView, 0.3)
        fadeInObject(appNameLabel, duration: 0.5, delay: 1.0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.changeRootViewController()
            })
        }
    }
    
    private func changeRootViewController() {
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = main.instantiateViewController(
            withIdentifier: "ScrapTabBarController"
        ) as? UITabBarController else { return }
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
    }
    
    private func animateObjectToScaleUp(_ object: UIView, _ delay: TimeInterval) {
        UIView.animate(withDuration: 0.4, delay: delay, options: .curveEaseIn, animations: {
            object.alpha = 0.0
            object.transform = CGAffineTransform(scaleX: 0.00, y: 0.00)
        }) { _ in
            self.scaleUp(object)
        }
    }
    
    private func fadeInObject(
        _ object: UIView,
        duration: TimeInterval,
        delay: TimeInterval,
        completion: @escaping () -> Void) {
        object.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            object.alpha = 1.0
        }) { _ in
            completion()
        }
    }
    
    private func scaleUp(_ view: UIView) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseIn, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        })
    }
}
