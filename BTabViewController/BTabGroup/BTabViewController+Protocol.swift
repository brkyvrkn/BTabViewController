//
//  BTabViewController+Protocol.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 31.07.2020
//  Copyright © 2020 foo. All rights reserved.
//

import UIKit

extension BTabViewController: BTabViewControllerProtocol {

    func listTab(_ target: UIViewController, didSelect item: BTabItemModel, index: Int) {
//        print(String(format: "%@\ntarget=%@\tselected=%@\tindex=%d", "BTabViewController:::::>\(#function)", target, item.title, index))
    }

    func listTab(_ target: UIViewController, tabSwitched to: BTabItemModel) {
//        print(String(format: "%@\ntarget=%@\tswitched to=%@", "BTabViewController:::::>\(#function)", target, to.title))
    }
    
}

