//
//  TableViewCell+Animator.swift
//  tree
//
//  Created by ParkSungJoon on 02/02/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import UIKit

/// TableView willDisplay에서 인자를 넘겨 받아 처리하기 위한 return typealias
typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

/// TableViewCell에 대한 다양한 애니메이션 효과 메소드를 정의할 수 있는 Factory
enum AnimationFactory {
    
    /**
     아핀변형을 이용해 TableViewCell을 위로 움직이면서 Fade효과를 줄 수 있는 메소드
     - Parameters:
        - rowHeight: Cell row의 높이
        - duration: Animation 지속 시간
        - delayFactor: Animate 효과 지연 시간
     */
    static func makeMoveUpWithFade(
        rowHeight: CGFloat,
        duration: TimeInterval,
        delayFactor: Double
    ) -> Animation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
    }
}

final class Animator {
    private var hasAnimatedCells = false
    private let animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    /// 현재 표시되는 TableViewCell의 마지막 indexPath Cell을 인지하여 hasAnimatedCells 값을 true로 변환하는 메소드
    func animate(to cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedCells else { return }
        animation(cell, indexPath, tableView)
        guard let lastIndexPath = tableView.indexPathsForVisibleRows?.last else { return }
        if lastIndexPath == indexPath {
            hasAnimatedCells = true
        } else {
            hasAnimatedCells = false
        }
    }
}
