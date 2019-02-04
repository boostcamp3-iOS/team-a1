//
//  SearchFilterViewController.swift
//  tree
//
//  Created by Hyeontae on 28/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {

    @IBOutlet weak var keywordSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSegment()
        roundCorners(layer: self.view.layer, radius: CGFloat(15.0))
    }
    
    private func settingSegment() {
        keywordSegmentedControl.backgroundColor = .clear
        sortSegmentedControl.backgroundColor = .clear
        keywordSegmentedControl.tintColor = .clear
        sortSegmentedControl.tintColor = .clear
        
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        
        keywordSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: font as Any,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        keywordSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: font as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
        sortSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: font as Any,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        sortSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.font: font as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .selected)
    }
    
    private func roundCorners(layer targetLayer: CALayer, radius withRaidus: CGFloat) {
        targetLayer.cornerRadius = withRaidus
        targetLayer.masksToBounds = true
    }
}
