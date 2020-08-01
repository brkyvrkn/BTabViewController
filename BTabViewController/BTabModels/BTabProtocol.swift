//
//  BTabProtocol.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 1.08.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit

public protocol BTabViewControllerProtocol: class {
    /// Trigger just tapping on the tab no matter the previous state
    /// - Parameters:
    ///   - target: Which container class did triggerred
    ///   - item: Selected tab item model
    ///   - index: Selected index order
    func listTab(_ target: UIViewController, didSelect item: BTabItemModel, index: Int)
    /// Called just changing operation did
    /// - Parameters:
    ///   - target: Container class just activated
    ///   - to: Newly changed tab model
    func listTab(_ target: UIViewController, tabSwitched to: BTabItemModel)
    func listTab(provideCell: BTabCellProvider) -> UICollectionViewCell
}
