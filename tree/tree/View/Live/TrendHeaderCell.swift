//
//  TrendHeaderCell.swift
//  tree
//
//  Created by ParkSungJoon on 02/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class HeaderCellContent {
    var title: String
    var country: String
    var expanded: Bool
    
    init(title: String, country: String) {
        self.title = title
        self.country = country
        self.expanded = false
    }
}

class TrendHeaderCell: UITableViewCell {
    
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var expandingStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var grayLineView: UIView!
    @IBOutlet var countries: [UIButton]!
    
    @IBOutlet var switchableConstraints: [NSLayoutConstraint]!
    
    private let innerMargin: CGFloat = 20.0
    private weak var shadowView: UIView?
    private var zeroHeightConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContainerView.layer.cornerRadius = 14
        makeRoundButtonWithBorder(for: countries)
        zeroHeightConstraint = expandingStackView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func layoutSubviews() {
        shadowView?.removeFromSuperview()
        configureShadow()
    }

    func configure(by content: HeaderCellContent) {
        titleLabel.text = content.title
        countryLabel.text = content.country
        if content.expanded {
            expandingStackView.isHidden = false
            grayLineView.isHidden = false
            zeroHeightConstraint?.isActive = false
            expandingStackView.spacing = 20
            for constraint in switchableConstraints {
                constraint.isActive = true
            }
        } else {
            expandingStackView.isHidden = true
            grayLineView.isHidden = true
            zeroHeightConstraint?.isActive = true
            expandingStackView.spacing = 0
            for constraint in switchableConstraints {
                constraint.isActive = false
            }
        }
    }
    
    private func configureShadow() {
        let shadowView = UIView(
            frame: CGRect(
                x: innerMargin,
                y: innerMargin,
                width: bounds.width - (2 * innerMargin),
                height: bounds.height - (2 * innerMargin))
        )
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
    
    private func makeRoundButtonWithBorder(for buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1.0
            button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 0.8045269692)
        }
    }
}
