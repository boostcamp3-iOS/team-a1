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
    @IBOutlet var collectionOfSegmentedControl: [UISegmentedControl]?
    
    private var selectViewIsPresented: Bool = false
    var filterValue: [String: String]?
    weak var settingDelegate: FilterSettingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupSegment()
        setupFilterValue()
        roundConersSetup()
    }
    
    private func setupPickerView() {
        selectPickViewer.delegate = self
        selectPickViewer.dataSource = self
    }
    
    private func setupFilterValue() {
        if let category = filterValue?["category"], let language = filterValue?["language"] {
            categoryLabel.text = category
            languageLabel.text = selectPickViewer.extractUserSelectedLan(selectedLabel: language)
        }
        if filterValue?["keyword"] == "Body" {
            keywordSegmentedControl.selectedSegmentIndex = 1
        }
        if filterValue?["sort"] == "Relevance" {
            sortSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func setupSegment() {
        pickerView.isHidden = true
        let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        let normalAttributedString = [ NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: UIColor.gray ]
        let selectedAttributedString = [ NSAttributedString.Key.font: font as Any, NSAttributedString.Key.foregroundColor: UIColor.black ]
        collectionOfSegmentedControl?.forEach({
            $0.backgroundColor = .clear
            $0.tintColor = .lightGray
            $0.setTitleTextAttributes(normalAttributedString, for: .normal)
            $0.setTitleTextAttributes(selectedAttributedString, for: .selected)
        })
    }
    
    private func roundConersSetup() {
        saveButton.roundCorners(layer: saveButton.layer, radius: CGFloat(5))
        view.roundCorners(layer: self.view.layer, radius: CGFloat(15))
    }
    
    private func makeHidden(isPresented: Bool) {
        languageStackView.isHidden = isPresented
        categoryStackView.isHidden = !isPresented
    }
    
    private func extractSelectedRow(selectedString: String) {
        let selectedRow = selectPickViewer.findRow(userValue: selectedString)
        selectPickViewer.selectRow(selectedRow, inComponent: 0, animated: true)
    }
    
    @IBAction func selectButtonClick(_ sender: UIButton) {
        selectViewIsPresented.toggle()
        selectPickViewer.tagNumber = sender.tag
        if selectViewIsPresented {
            switch selectPickViewer.pickerType {
            case .category:
                makeHidden(isPresented: selectViewIsPresented)
                if let categoryText = categoryLabel.text {
                    extractSelectedRow(selectedString: categoryText)
                }
            case .language:
                makeHidden(isPresented: !selectViewIsPresented)
                if let languageText = languageLabel.text {
                    extractSelectedRow(selectedString: languageText)
                }
            }
            saveButton.isHidden = true
        } else {
            languageStackView.isHidden = selectViewIsPresented
            categoryStackView.isHidden = selectViewIsPresented
            saveButton.isHidden = false
        }
        UIView.animate(withDuration: 0.3) { 
            self.keywordSortStackView.isHidden = self.selectViewIsPresented
            self.pickerView.isHidden = !self.selectViewIsPresented
        }
    }
   
    @IBAction func saveButtonClick(_ sender: Any) {
        guard let keyword = keywordSegmentedControl.titleForSegment(at: keywordSegmentedControl.selectedSegmentIndex), 
            let sort = sortSegmentedControl.titleForSegment(at: sortSegmentedControl.selectedSegmentIndex), 
            let category = categoryLabel.text,
            let language = languageLabel.text,
            let lan = selectPickViewer.extractUserSelectedLanguage(selectedItem: language)
            else { return }
        settingDelegate?.observeUserSetting(
            keyword: keyword,
            sort: sort,
            category: category, 
            language: lan
        )

        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectPickViewer.pickerItemList().count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectValue = selectPickViewer.pickerItemList()[row]
        switch selectPickViewer.pickerType {
        case .category:
            categoryLabel.text = selectValue
        case .language:
            languageLabel.text = selectValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectPickViewer.pickerItemList()[row]
    }
}
