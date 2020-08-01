//
//  BTabItem.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 1.08.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit

/// Order should begin with zero
public struct BTabItemModel: Equatable {
    // Attributes
    public var order: Int
    public var title: String
    public var titleFont: UIFont = .systemFont(ofSize: 12)
    public var titleTextColor: UIColor = .init(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    public var highlightFont: UIFont = .systemFont(ofSize: 12, weight: .bold)
    public var highlightTextColor: UIColor = .init(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    public var backgroundColor: UIColor = .clear
    public var textAlignment: NSTextAlignment = .left
    // Private protection level attributes
    private var isActive: Bool = false

    /// Tab item initializer, required just 2 variables
    /// - Parameters:
    ///   - order: Left-most index position of given tab
    ///   - title: Text
    public init(order: Int, title: String) {
        self.order = order
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
    }

    mutating func setActive(_ isActive: Bool) {
        self.isActive = isActive
    }

    public func getActive() -> Bool {
        return self.isActive
    }

    /// Equatable overloader
    /// - Parameters:
    ///   - lhs: Left hand side
    ///   - rhs: Right hand side
    /// - Returns: True if their orders are equal
    public static func ==(lhs: BTabItemModel, rhs: BTabItemModel) -> Bool {
        return lhs.order == rhs.order
    }
}
