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
        let vcTemp = UIViewController()
        let listItem = BTabModel(id: "1", target: vcTemp)
        XCTAssert(listItem.id == "1")
        XCTAssertEqual(listItem.target, vcTemp)
    }

    func testTabListModelInit2() throws {
        let vcTemp = UIViewController()
        let listItem = BTabModel(id: "1", target: vcTemp)
        XCTAssert(listItem.id == "1")
        XCTAssertNotEqual(listItem.target, UIViewController())
    }

    func testTabListModelInit3() throws {
        let vcTemp = UIViewController()
        let listItem = BTabModel(id: "2", target: vcTemp)
        XCTAssertEqual(listItem.id, "2")
        XCTAssertNotEqual(listItem.target, UIViewController())
    }

    func testTabListModelInit4() throws {
        let vcTemp = UIViewController()
        let listItem = BTabModel(id: "2", target: vcTemp)
        XCTAssertNotEqual(listItem.id, "1")
        XCTAssertEqual(listItem.target, vcTemp)
    }

    func testTabVCInit() throws {
        let vcTemp = BTabViewController()
        XCTAssertEqual(vcTemp.containers.count, 0)
        XCTAssertEqual(vcTemp.tabList.count, 0)
        XCTAssertEqual(vcTemp.tabItems.count, 0)
        XCTAssertNil(vcTemp.horizontalScrollView)
    }

    func testTabVCInit2() throws {
        let vcTemp = BTabViewController()
        XCTAssertEqual(vcTemp.containers.count, 0)
        XCTAssertEqual(vcTemp.tabList.count, 0)
        XCTAssertEqual(vcTemp.tabItems.count, 0)
        XCTAssertNil(vcTemp.tabCollectionView)
    }

    func testTabVCInit3() throws {
        let vcTemp = BTabViewController()
        XCTAssertEqual(vcTemp.containers.count, 0)
        XCTAssertEqual(vcTemp.tabList.count, 0)
        XCTAssertEqual(vcTemp.tabItems.count, 0)
        XCTAssertNil(vcTemp.selectedTabItem)
    }

    func testTabCollectionInit() throws {
        let cell = BTabCell()
        XCTAssertNotNil(cell.nameLabel)
    }

    func testTabCollectionInit2() throws {
        let cell = BTabCell()
        XCTAssertNil(cell.model)
    }

    func testTabCollectionConfiguration() throws {
        let cell = BTabCell()
        let item = BTabItemModel(order: 0, title: "1")
        cell.configureCell(item)
        XCTAssertNotNil(cell.model)
    }

    func testTabCollectionAwake() throws {
        let cell = BTabCell()
        cell.awakeFromNib()
        XCTAssertNil(cell.model)
        XCTAssertNotNil(cell.nameLabel)
    }

    func testTabCollectionIdentifier() throws {
        XCTAssertEqual("BTabCell", BTabCell.identifier)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {

        }
    }

}
