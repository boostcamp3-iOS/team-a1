//
//  DefautLabelView.swift
//  tree
//
//  Created by hyeri kim on 08/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class DefaultLabelView: UIView {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var defaultMessageLabel: UILabel!
    
    private let xibName = "DefaultLabelView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        initXIB()
        setRadius()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initXIB()
        setRadius()
    }
    
    private func initXIB() {
        guard let view = Bundle.main.loadNibNamed(
            xibName,
            owner: self,
            options: nil)?.first as? UIView 
            else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func setRadius() {
        let radius: CGFloat = 10
        outerView.roundCorners(layer: outerView.layer, radius: radius)
    }
}
