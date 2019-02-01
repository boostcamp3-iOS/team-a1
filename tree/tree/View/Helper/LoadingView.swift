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
        startAnimation()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initXIB()
        setRadius()
        startAnimation()
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
        let radius: CGFloat = 5 
        dot1.layer.cornerRadius = radius
        dot2.layer.cornerRadius = radius
        dot3.layer.cornerRadius = radius
    }
  
    private func startAnimation() {
        dot1.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dot2.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dot3.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.dot1.transform = CGAffineTransform.identity
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.dot2.transform = CGAffineTransform.identity
        }, completion: nil)
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.dot3.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
