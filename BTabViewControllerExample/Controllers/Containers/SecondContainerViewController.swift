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
    override func setView(tabList: [BTabModel], tabItems: [BTabItemModel]) {
        let fourthTabVC = ExampleStoryboards.instantiateViewController(in: .tabs, classOf: FourthTabViewController.self)!
        let fifthTabVC = ExampleStoryboards.instantiateViewController(in: .tabs, classOf: FifthTabViewController.self)!
        let sixthTabVC = ExampleStoryboards.instantiateViewController(in: .tabs, classOf: SixthTabViewController.self)!
        let fourthList = BTabModel(id: "4", target: fourthTabVC)
        let fifthList = BTabModel(id: "5", target: fifthTabVC)
        let sixthList = BTabModel(id: "6", target: sixthTabVC)
        let lists = [fourthList, fifthList, sixthList]

        var fourthTab = BTabItemModel(order: 0, title: "Four")
//        fourthTab.backgroundColor = .blue
        fourthTab.highlightFont = .systemFont(ofSize: 16, weight: .bold)
        var fifthTab = BTabItemModel(order: 1, title: "Five")
//        fifthTab.backgroundColor = .green
        fifthTab.highlightFont = .systemFont(ofSize: 16, weight: .bold)
        var sixthTab = BTabItemModel(order: 2, title: "Six")
//        sixthTab.backgroundColor = .yellow
        sixthTab.highlightFont = .systemFont(ofSize: 16, weight: .bold)
        let tabs: [BTabItemModel] = [fourthTab, fifthTab, sixthTab]

        self.tabsGap = 8
        self.tabInset = 20
        self.tabsHeight = 30
        self.isIndicatorVisible = true
        self.indicatorHeight = 4
        self.indicatorWidth = 16
        self.indicatorIsRounded = true
        self.tabWidth = 40

        super.setView(tabList: lists, tabItems: tabs)
    }

    override func listTab(_ target: UIViewController, tabSwitched toItem: BTabItemModel) {
        super.listTab(target, tabSwitched: toItem)
    }
}
