//
//  SecondContainerViewController.swift
//  BTabViewControllerExample
//
//  Created by Berkay Vurkan on 31.07.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit
import BTabViewController

class SecondContainerViewController: BTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - BTab Stuff
    override func setView(tabList: [BTabListModel], tabItems: [BTabItemModel]) {
        
    }

    override func listTab(_ target: UIViewController, tabSwitched to: BTabItemModel) {
        super.listTab(target, tabSwitched: to)
    }
}
