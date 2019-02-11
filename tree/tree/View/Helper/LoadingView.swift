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
    @IBOutlet var dots: [UIView]!
    
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
            options: nil)?.first as? UIView 
            else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }

    private func setRadius() {
        let radius: CGFloat = 5
        for dot in dots {
            dot.layer.cornerRadius = radius
        }
    }
  
    private func startAnimation() {
        for index in 0..<dots.count {
            dots[index].transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(
                withDuration: 0.6,
                delay: Double(index-1) * 0.2,
                options: [.repeat, .autoreverse],
                animations: {
                self.dots[index].transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
