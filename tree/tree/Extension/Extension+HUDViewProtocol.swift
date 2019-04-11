//
//  Extension+HUDViewProtocol.swift
//  tree
//
//  Created by Hyeontae on 07/04/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

extension HUDViewProtocol {
    func hud(inView view: UIView, text: String) {
        let myRect = CGRect(x: view.center.x-48, y: view.center.y-48, width: 96, height: 96)
        let hudView: HUDView = HUDView(frame: myRect)
        hudView.centerTextLabel.text = text
        hudView.isOpaque = false
        hudView.show(animted: true)
        view.addSubview(hudView)
    }
    
}
