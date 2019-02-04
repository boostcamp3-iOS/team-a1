//
//  SearchFilterViewController.swift
//  tree
//
//  Created by Hyeontae on 28/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {

    @IBOutlet weak var pickerView: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var keywordSortStackView: UIStackView!
    @IBOutlet weak var keywordSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    private var selectViewIsPresented: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorners(layer: saveButton.layer, radius: CGFloat(5))
        roundCorners(layer: self.view.layer, radius: CGFloat(15.0))
    }
    
    private func settingSegment() {
        pickerView.isHidden = true
        keywordSegmentedControl.backgroundColor = .clear
        sortSegmentedControl.backgroundColor = .clear
        keywordSegmentedControl.tintColor = .clear
        sortSegmentedControl.tintColor = .clear
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        let normalAttributedString = [ NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: UIColor.lightGray ]
        let selectedAttributedString = [ NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: UIColor.black ]
        keywordSegmentedControl.setTitleTextAttributes(normalAttributedString, for: .normal)
        keywordSegmentedControl.setTitleTextAttributes(selectedAttributedString, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(normalAttributedString, for: .normal)
        sortSegmentedControl.setTitleTextAttributes(selectedAttributedString, for: .selected)
    }
    
    private func roundCorners(layer targetLayer: CALayer, radius withRaidus: CGFloat) {
        targetLayer.cornerRadius = withRaidus
        targetLayer.masksToBounds = true
    }
    
    @IBAction func selectButtonClick(_ sender: Any) {
        selectViewIsPresented.toggle()
        UIView.animate(withDuration: 0.3) { 
            self.keywordSortStackView.isHidden = !self.selectViewIsPresented
            self.pickerView.isHidden = self.selectViewIsPresented
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
