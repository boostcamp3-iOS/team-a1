//
//  TrendHeaderCell.swift
//  tree
//
//  Created by ParkSungJoon on 02/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

protocol ExpandableHeaderDelegate: class {
    func tappedCountryButton(_ country: String)
}

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
    @IBOutlet var countryButtons: [UIButton]!
    @IBOutlet var switchableConstraints: [NSLayoutConstraint]!
    
    private var zeroHeightConstraint: NSLayoutConstraint?
    private weak var shadowView: UIView?
    weak var expandableHeaderDelegate: ExpandableHeaderDelegate?
    private let innerMargin: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        zeroHeightConstraint = expandingStackView.heightAnchor.constraint(equalToConstant: 0)
        setButtonTagAndAction(at: countryButtons)
        makeRoundView(for: backgroundContainerView)
        countryButtons.forEach { (button) in
            makeCountryButtonUI(
                for: button,
                radius: 20,
                borderWidth: 1.0,
                borderColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1),
                textColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
            )
        }
    }
    
    override func layoutSubviews() {
        shadowView?.removeFromSuperview()
        configureShadow()
    }

    func configure(by content: HeaderCellContent) {
        titleLabel.text = content.title
        countryLabel.text = content.country
        hideExpandedViewIf(content.expanded)
    }
    
    private func hideExpandedViewIf(_ expanded: Bool) {
        expandingStackView.isHidden = !expanded
        grayLineView.isHidden = !expanded
        zeroHeightConstraint?.isActive = !expanded
        expandingStackView.spacing = expanded ? 20 : 0
        for constraint in switchableConstraints {
            constraint.isActive = expanded
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
    
    private func makeRoundView(for view: UIView) {
        view.layer.cornerRadius = 14
    }
    
    private func makeCountryButtonUI(
        for button: UIButton,
        radius: CGFloat,
        borderWidth: CGFloat,
        borderColor: CGColor,
        textColor: UIColor
    ) {
        button.layer.cornerRadius = radius
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor
        button.setTitleColor(textColor, for: .normal)
    }
    
    private func setButtonTagAndAction(at buttons: [UIButton]) {
        for index in 0..<buttons.count {
            buttons[index].tag = index
            buttons[index].addTarget(
                self,
                action: #selector(didSelectCountry(_:)),
                for: .touchUpInside
            )
        }
    }
    
    private func whenPressedButtonUISetting(_ button: UIButton) {
        countryButtons.forEach {
            if $0.tag == button.tag {
                makeCountryButtonUI(
                    for: $0,
                    radius: 20,
                    borderWidth: 2.0,
                    borderColor: UIColor.brightBlue.cgColor,
                    textColor: UIColor.brightBlue
                )
            } else {
                makeCountryButtonUI(
                    for: $0,
                    radius: 20,
                    borderWidth: 1.0,
                    borderColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1),
                    textColor: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
                )
            }
        }
    }
    
    @objc private func didSelectCountry(_ button: UIButton) {
        guard
            let name = Country(rawValue: button.tag)?.info.name,
            let code = Country(rawValue: button.tag)?.info.code
            else { return }
        whenPressedButtonUISetting(button)
        NotificationCenter.default.post(
            name: .observeCountryChanging,
            object: nil,
            userInfo: ["name": name, "code": code]
        )
        expandableHeaderDelegate?.tappedCountryButton(name)
    }
}
