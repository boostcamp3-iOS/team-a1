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
    var filterValue: [String: String]?
    var settingDelegate: FilterSettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingSegment()
        registerDelegate()
        settingFilterValue()
        roundCorners(layer: saveButton.layer, radius: CGFloat(5))
        roundCorners(layer: self.view.layer, radius: CGFloat(15.0))
    }
    
    private func registerDelegate() {
        selectPickViewer.delegate = self
        selectPickViewer.dataSource = self
    }
    
    private func settingFilterValue() {
        guard let keyword = filterValue?["keyword"], let sort = filterValue?["sort"] else { return }
        categoryLabel.text = filterValue?["category"]
        languageLabel.text = filterValue?["language"]
        switch keyword {
        case "Title":
            keywordSegmentedControl.selectedSegmentIndex = 0
        default:
            keywordSegmentedControl.selectedSegmentIndex = 1
        }
        switch sort {
        case "Date":
            sortSegmentedControl.selectedSegmentIndex = 0
        default:
            sortSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func settingSegment() {
        pickerView.isHidden = true
        keywordSegmentedControl.backgroundColor = .clear
        sortSegmentedControl.backgroundColor = .clear
        keywordSegmentedControl.tintColor = .lightGray
        sortSegmentedControl.tintColor = .lightGray
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        let normalAttributedString = [ NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: UIColor.gray ]
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
        if let keyword = keywordSegmentedControl.titleForSegment(at: keywordSegmentedControl.selectedSegmentIndex), let sort = sortSegmentedControl.titleForSegment(at: sortSegmentedControl.selectedSegmentIndex), let category = categoryLabel.text, let language = languageLabel.text {
            settingDelegate?.observeUserSetting(keyword: keyword, sort: sort, category: category, language: language)
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
            categoryLabel.text = selectValue
        } else {
            languageLabel.text = selectValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectPickViewer.getList()[row]
    }
}
