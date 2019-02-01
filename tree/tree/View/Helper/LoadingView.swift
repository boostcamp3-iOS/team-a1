//
//  LoadingView.swift
//  tree
//
//  Created by hyeri kim on 01/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dot3: UIView!
    
    private let xibName = "LoadingView"
    
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
            options: nil
            )?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }

    private func setRadius() {
        let circle: CGFloat = 5 
        dot1.layer.cornerRadius = circle
        dot2.layer.cornerRadius = circle
        dot3.layer.cornerRadius = circle
    }
  
}
