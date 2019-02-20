//
//  ScrapTabBarController.swift
//  tree
//
//  Created by Hyeontae on 04/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ScrapTabBarController: UITabBarController {

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 0.8, 1.2, 1.0]
        bounceAnimation.duration = 0.3
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let tabBarViewControllers = self.viewControllers else { return }
        let navigationControllerArr = tabBarViewControllers.filter{ $0 is ScrapConnected }
        guard let scrapNavigationController =
            navigationControllerArr.first as? ScrapNavigationController else { return }
        guard let scrapViewController =
            scrapNavigationController.viewControllers.first as? ScrapViewController else { return }
        appDelegate.scrapViewController = scrapViewController

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.scrapViewController?.setupScrapBadgeValue()
    }
}

extension ScrapTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard 
            let index = tabBar.items?.index(of: item), 
            let imageView = tabBar.subviews[index + 1]
                .subviews
                .compactMap({$0 as? UIImageView})
                .first
            else {
            return
        }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
