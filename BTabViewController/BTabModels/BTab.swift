//
//  BTab.swift
//  BTabViewController
//
//  Created by Berkay Vurkan on 1.08.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit

/// To define child view controllers and their id
public struct BTabModel {
    // Attributes
    public var id: String
    public var target: UIViewController

    /// Initializer
    /// - Parameters:
    ///   - id: Identifier of target
    ///   - target: View controller target for child
    public init(id: String, target: UIViewController) {
        self.id = id
        self.target = target
    }
}
