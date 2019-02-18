//
//  Extension+UIViewController.swift
//  tree
//
//  Created by ParkSungJoon on 17/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createAlertController(title: String, message: String, hasHandler: Bool) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        if !hasHandler {
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
        }
        return alertController
    }
}
