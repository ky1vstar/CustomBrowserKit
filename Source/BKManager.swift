//
//  BKManager.swift
//  CustomBrowserKit
//
//  Created by ky1vstar on 03/25/2018.
//  Copyright (c) 2018 ky1vstar. All rights reserved.
//

import Foundation

extension BKManager {
    
    /// An array of currently installed browsers.
    ///
    /// - seealso: -isBrowserAvailable:
    open class var availableBrowsers: [BKBrowser] {
        return __availableBrowsers.map { BKBrowser(rawValue: $0.intValue)! }
    }
    
}
