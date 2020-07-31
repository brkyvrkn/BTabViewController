//
//  ExampleStoryboards.swift
//  BTabViewControllerExample
//
//  Created by Berkay Vurkan on 31.07.2020.
//  Copyright © 2020 Foo. All rights reserved.
//

import UIKit

enum ExampleStoryboardType: String {
    case launch = "LaunchScreen"
    case main   = "Main"
    case tabs   = "Tabs"
}

class ExampleStoryboards {

    /// Assume the given class name same as its storyboard id
    /// - Parameters:
    ///   - storyboard: Storyboard enum
    ///   - classOf: Given class
    class func instantiateViewController<T: Any>(in storyboard: ExampleStoryboardType, classOf: T) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: classOf))
    }
}
