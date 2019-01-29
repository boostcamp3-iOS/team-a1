//
//  SearchFilterViewController.swift
//  tree
//
//  Created by Hyeontae on 28/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        roundCorners(layer: self.view.layer, radius: CGFloat(15.0))
    }
    
    func roundCorners(layer targetLayer: CALayer, radius withRaidus: CGFloat) {
        targetLayer.cornerRadius = withRaidus
        targetLayer.masksToBounds = true
    }
}
