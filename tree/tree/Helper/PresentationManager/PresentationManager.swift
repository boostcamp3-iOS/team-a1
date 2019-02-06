//
//  PresentationManager.swift
//  tree
//
//  Created by Hyeontae on 28/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class PresentationManager: NSObject {
    
}

extension PresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController
        ) -> UIPresentationController? {
        let presentationController = PresentationController(presentedViewController: presented,
                                                            presenting: presenting)
        return presentationController
    }
}
