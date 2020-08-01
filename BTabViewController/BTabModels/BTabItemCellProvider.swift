//
//  BTabItemCellProvider.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 1.08.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit

/// Cell register provider in order to customize tab items
/// - Note: Recommend to use the class type providing instead of NIB
public struct BTabCellProvider {
    public var nib: UINib?
    public var identifier: String
    public var _class: AnyClass?
    public var forSupplementaryViewOfKind: String?

    /// Initializer by using class of coder
    /// - Parameters:
    ///   - reuseIdentifier: Identifier of the custom cell
    ///   - _class: Class of cell
    ///   - forSupplementaryViewOfKind: Set if you need both class and supplementary
    init(reuseIdentifier: String, _class: AnyClass?, forSupplementaryViewOfKind: String? = nil) {
        self.identifier = reuseIdentifier
        self._class = _class
        self.forSupplementaryViewOfKind = forSupplementaryViewOfKind
    }

    /// Initializer by using nib
    /// - Parameters:
    ///   - reuseIdentifier: Identifier of the custom cell
    ///   - nib: Nib object of cell
    ///   - forSupplementaryViewOfKind: Set if you need both nib and supplementary
    init(reuseIdentifier: String, nib: UINib?, forSupplementaryViewOfKind: String? = nil) {
        self.identifier = reuseIdentifier
        self.nib = nib
        self.forSupplementaryViewOfKind = forSupplementaryViewOfKind
    }
}
