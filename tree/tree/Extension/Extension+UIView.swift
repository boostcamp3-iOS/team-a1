//
//  Extension+UIView.swift
//  tree
//
//  Created by hyeri kim on 30/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

extension UIView {
    func applyShadow(shadowView: UIView, width: CGFloat, height: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 14.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: width, height: height)
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowPath = shadowPath.cgPath
    }
    
    func roundCorners(layer targetLayer: CALayer, radius withRaidus: CGFloat) {
        targetLayer.cornerRadius = withRaidus
        targetLayer.masksToBounds = true
    }
}
