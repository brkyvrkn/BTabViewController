//
//  FirstContainerViewController.swift
//  BTabViewControllerExample
//
//  Created by Berkay Vurkan on 31.07.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit
import BTabViewController

class FirstContainerViewController: BTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - BTab Stuff
    override func setView(tabList: [BTabModel], tabItems: [BTabItemModel]) {
        let firstTabVC = ExampleStoryboards.instantiateViewController(in: .tabs, classOf: FirstTabViewController.self)!
        let secondTabVC = ExampleStoryboards.instantiateViewController(in: .tabs, classOf: SecondTabViewController.self)!
        let thirdTabVC = ExampleStoryboards.instantiateViewController(in: .tabs, classOf: ThirdTabViewController.self)!
        let firstList = BTabModel(id: "1", target: firstTabVC)
        let secondList = BTabModel(id: "2", target: secondTabVC)
        let thirdList = BTabModel(id: "3", target: thirdTabVC)
        let lists = [firstList, secondList, thirdList]

        var firstTab = BTabItemModel(order: 0, title: "First")
//        firstTab.backgroundColor = .blue
        firstTab.highlightFont = .systemFont(ofSize: 16, weight: .bold)
        firstTab.textAlignment = .center
        var secondTab = BTabItemModel(order: 1, title: "Second")
//        secondTab.backgroundColor = .green
        secondTab.highlightFont = .systemFont(ofSize: 16, weight: .bold)
        secondTab.textAlignment = .center
        var thirdTab = BTabItemModel(order: 2, title: "Third")
//        thirdTab.backgroundColor = .yellow
        thirdTab.highlightFont = .systemFont(ofSize: 16, weight: .bold)
        thirdTab.textAlignment = .center
        let tabs: [BTabItemModel] = [firstTab, secondTab, thirdTab]

        self.tabsGap = 0
        self.tabInset = 0
        self.tabsHeight = 30
        self.fitTabs = true
        self.isIndicatorVisible = false

        super.setView(tabList: lists, tabItems: tabs)
    }

    override func listTab(_ target: UIViewController, tabSwitched to: BTabItemModel) {
        
    }
}
