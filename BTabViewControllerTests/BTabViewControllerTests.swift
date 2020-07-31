//
//  BTabViewControllerTests.swift
//  BTabViewControllerTests
//
//  Created by Berkay Vurkan on 31.07.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import XCTest
@testable import BTabViewController

class BTabViewControllerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tab Items
    func testTabItemModelInit() throws {
        let tabItem = BTabItemModel(order: 0, title: "first")
        XCTAssert(tabItem.order == 0)
        XCTAssert(tabItem.title == "first".capitalized)
        XCTAssertFalse(tabItem.getActive())
        XCTAssertNotNil(tabItem.backgroundColor)
        XCTAssertNotNil(tabItem.highlightFont)
        XCTAssertNotNil(tabItem.highlightTextColor)
        XCTAssertNotNil(tabItem.textAlignment)
        XCTAssertNotNil(tabItem.titleFont)
        XCTAssertNotNil(tabItem.titleTextColor)
    }

    func testTabItemModelCompare1() throws {
        let tabItem = BTabItemModel(order: 0, title: "first")
        let tabItem2 = BTabItemModel(order: 0, title: "first")
        XCTAssertTrue(tabItem == tabItem2)
    }

    func testTabItemModelCompare2() throws {
        let tabItem = BTabItemModel(order: 0, title: "first")
        let tabItem2 = BTabItemModel(order: 0, title: "second")
        XCTAssertTrue(tabItem == tabItem2)
    }

    func testTabItemModelCompare3() throws {
        let tabItem = BTabItemModel(order: 0, title: "first")
        let tabItem2 = BTabItemModel(order: 1, title: "first")
        XCTAssertFalse(tabItem == tabItem2)
    }

    func testTabItemModelCompare4() throws {
        let tabItem = BTabItemModel(order: 0, title: "first")
        let tabItem2 = BTabItemModel(order: 1, title: "second")
        XCTAssertFalse(tabItem == tabItem2)
    }

    func testTabListModelInit() throws {
        let vc = UIViewController()
        let listItem = BTabListModel(id: "1", target: vc)
        XCTAssert(listItem.id == "1")
        XCTAssertEqual(listItem.target, vc)
    }

    func testTabListModelInit2() throws {
        let vc = UIViewController()
        let listItem = BTabListModel(id: "1", target: vc)
        XCTAssert(listItem.id == "1")
        XCTAssertNotEqual(listItem.target, UIViewController())
    }

    func testTabListModelInit3() throws {
        let vc = UIViewController()
        let listItem = BTabListModel(id: "2", target: vc)
        XCTAssertEqual(listItem.id, "2")
        XCTAssertNotEqual(listItem.target, UIViewController())
    }

    func testTabListModelInit4() throws {
        let vc = UIViewController()
        let listItem = BTabListModel(id: "2", target: vc)
        XCTAssertNotEqual(listItem.id, "1")
        XCTAssertEqual(listItem.target, vc)
    }

    func testTabVCInit() throws {
        let vc = BTabViewController()
        XCTAssertEqual(vc.containers.count, 0)
        XCTAssertEqual(vc.tabList.count, 0)
        XCTAssertEqual(vc.tabItems.count, 0)
        XCTAssertNil(vc.horizontalScrollView)
    }

    func testTabVCInit2() throws {
        let vc = BTabViewController()
        XCTAssertEqual(vc.containers.count, 0)
        XCTAssertEqual(vc.tabList.count, 0)
        XCTAssertEqual(vc.tabItems.count, 0)
        XCTAssertNil(vc.tabCollectionView)
    }

    func testTabVCInit3() throws {
        let vc = BTabViewController()
        XCTAssertEqual(vc.containers.count, 0)
        XCTAssertEqual(vc.tabList.count, 0)
        XCTAssertEqual(vc.tabItems.count, 0)
        XCTAssertNil(vc.selectedTab)
    }

    func testTabCollectionInit() throws {
        let cell = BTabCollectionViewCell()
        XCTAssertNil(cell.nameLabel)
    }

    func testTabCollectionInit2() throws {
        let cell = BTabCollectionViewCell()
        XCTAssertNil(cell.model)
    }

    func testTabCollectionConfiguration() throws {
        let cell = BTabCollectionViewCell()
        let item = BTabItemModel(order: 0, title: "1")
        cell.configureCell(item)
        XCTAssertNotNil(cell.model)
    }

    func testTabCollectionAwake() throws {
        let cell = BTabCollectionViewCell()
        cell.awakeFromNib()
        XCTAssertNil(cell.model)
        XCTAssertNil(cell.nameLabel)
    }

    func testTabCollectionIdentifier() throws {
        XCTAssertEqual("BTabCollectionViewCell", BTabCollectionViewCell.identifier)
    }

    func testTabCollectionNibName() throws {
        XCTAssertEqual("BTabCollectionViewCell", BTabCollectionViewCell.nibName)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {

        }
    }

}
