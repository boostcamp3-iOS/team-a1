//
//  ArticleDetailViewController.swift
//  tree
//
//  Created by hyerikim on 22/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ArticleDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
