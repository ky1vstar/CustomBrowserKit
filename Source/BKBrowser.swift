//
//  BKBrowser.swift
//  CustomBrowserKit
//
//  Created by ky1vstar on 03/25/2018.
//  Copyright (c) 2018 ky1vstar. All rights reserved.
//

import Foundation

extension BKBrowser: CustomStringConvertible {

    /// Initialize browser with specified identifier string. It can be used to restore `BKBrowser` from `UserDefaults`.
    /// - note: If identifier is not supported, `.safari` will be returned
    public init(identifier: String) {
        self = __BKBrowserFromIdentifier(identifier)
    }
    
    /// Identifier string for the specified browser. It can be used to save `BKBrowser` to `UserDefaults`.
    public var identifier: String {
        return __BKBrowserGetIdentifier(self)
    }
    
    /// Name of the current browser.
    public var name: String {
        return __BKBrowserGetName(self)
    }
    
    /// Thumbnail image for the current browser.
    /// - note: `nil` if current browser is `.inAppSafari`, image of size 100x100 otherwise
    public var thumbnail: UIImage? {
        return __BKBrowserGetThumbnail(self)
    }
    
    public var description: String {
        return "BKBrowser.\(identifier)"
    }
    
}
