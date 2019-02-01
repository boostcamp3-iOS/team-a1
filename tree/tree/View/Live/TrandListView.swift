//
//  TrandListView.swift
//  tree
//
//  Created by ParkSungJoon on 31/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class TrandListView: UIView {

    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subscriptLabel: UILabel!
    
    private let xibName = "TrandListView"
    private weak var shadowView: UIView?
    private let innerMargin: CGFloat = 20.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initXIB()
        backgroundContainerView.layer.cornerRadius = 14
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    private func initXIB(){
        guard let view = Bundle.main.loadNibNamed(
            xibName,
            owner: self,
            options: nil
            )?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func configureShadow() {
        let shadowView = UIView(frame: CGRect(x: innerMargin,
                                              y: innerMargin,
                                              width: bounds.width - (2 * innerMargin),
                                              height: bounds.height - (2 * innerMargin)
                                ))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        self.applyShadow(
            shadowView: shadowView,
            width: CGFloat(0.0),
            height: CGFloat(0.0)
        )
    }
    
    private func applyShadow(shadowView: UIView, width: CGFloat, height: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 14.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: width, height: height)
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowPath = shadowPath.cgPath
    }
}
