//
//  SearchFilterViewController.swift
//  tree
//
//  Created by Hyeontae on 28/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {

    @IBOutlet weak var languageStackView: UIStackView!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectPickViewer: PickerView!
    @IBOutlet weak var pickerView: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var keywordSortStackView: UIStackView!
    @IBOutlet weak var keywordSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!

    private var selectViewIsPresented: Bool = false
    private var selectedCategory: String = "all"
    private var selectedLanguage: String = "eng"
    var settingDelegate: FilterSettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSegment()
        registerDelegate()
        roundCorners(layer: saveButton.layer, radius: CGFloat(5))
        roundCorners(layer: self.view.layer, radius: CGFloat(15.0))
    }
    
    private func registerDelegate() {
        selectPickViewer.delegate = self
        selectPickViewer.dataSource = self
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
    
    @IBAction func selectButtonClick(_ sender: UIButton) {
        selectViewIsPresented.toggle()
        selectPickViewer.tagNumber = sender.tag
        if selectViewIsPresented {
            if selectPickViewer.tagNumber == 0 {
                languageStackView.isHidden = selectViewIsPresented
                categoryStackView.isHidden = !selectViewIsPresented
            } else {
                languageStackView.isHidden = !selectViewIsPresented
                categoryStackView.isHidden = selectViewIsPresented
            }
        } else {
            languageStackView.isHidden = selectViewIsPresented
            categoryStackView.isHidden = selectViewIsPresented
        }
        UIView.animate(withDuration: 0.3) { 
            self.keywordSortStackView.isHidden = self.selectViewIsPresented
            self.pickerView.isHidden = !self.selectViewIsPresented
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if let keyword = keywordSegmentedControl.titleForSegment(at: keywordSegmentedControl.selectedSegmentIndex), let sort = sortSegmentedControl.titleForSegment(at: sortSegmentedControl.selectedSegmentIndex) {
            settingDelegate?.observeUserSetting(keyword: keyword, sort: sort, category: selectedCategory, language: selectedLanguage)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectPickViewer.getList().count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectValue = selectPickViewer.getList()[row]
        if selectPickViewer.tagNumber == 0 {
            selectedCategory = selectValue
            categoryLabel.text = selectValue
        } else {
            selectedLanguage = selectValue
            languageLabel.text = selectValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectPickViewer.getList()[row]
    }
}
