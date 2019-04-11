//
//  HUDView.swift
//  tree
//
//  Created by Hyeontae on 07/04/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class HUDView: UIView {
    
    @IBOutlet weak var centerTextLabel: UILabel!
    
    private let xibName = "HUDView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let hudview =
            Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first
                as? UIView else { return }
        self.addSubview(hudview)
        hudview.frame = bounds
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
    }
    
    private func removeXib(after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.removeFromSuperview()
        }
    }
    
    func show(animted: Bool) {
        if animted {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            }) { (_) in
                self.removeXib(after: 0.6)
            }
        }
    }

}
