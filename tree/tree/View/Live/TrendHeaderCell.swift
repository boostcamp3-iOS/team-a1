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

protocol SelectedDelegate: class {
    func passSelectedCountryInfo(_ name: String, _ code: String)
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
    private let innerMargin: CGFloat = 20.0
    weak var delegate: SelectedDelegate?
    
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
        when(content.expanded)
    }
    
    private func when(_ expanded: Bool) {
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
    
    private func applyShadow(shadowView: UIView, width: CGFloat, height: CGFloat) {
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 14.0)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 14.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: width, height: height)
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowPath = shadowPath.cgPath
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
        delegate?.passSelectedCountryInfo(name, code)
    }
}
