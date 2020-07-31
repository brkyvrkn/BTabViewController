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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
