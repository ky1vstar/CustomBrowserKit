//
//  BKBrowser.h
//  CustomBrowserKit
//
//  Created by ky1vstar on 03/25/2018.
//  Copyright (c) 2018 ky1vstar. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 An enumeration for the various browsers.
 */
typedef NS_ENUM(NSInteger, BKBrowser) {
    BKBrowserChrome,
    BKBrowserFirefox,
    BKBrowserOpera,
    BKBrowserUCBrowser,
    BKBrowserPuffin,
    BKBrowserYandexBrowser,
    
    BKBrowserInAppSafari, /*NS_ENUM_AVAILABLE_IOS(9_0)*/
    BKBrowserSafari
};


NS_ASSUME_NONNULL_BEGIN

/**
 Returns identifier string for the specified browser. It can be used to save `BKBrowser` to `NSUserDefaults`.
 
 @param browser The browser for which identifier is required.
 
 @return Browser identifier string
 */
NSString *BKBrowserGetIdentifier(BKBrowser browser) NS_REFINED_FOR_SWIFT;


/**
 Returns browser for the specified identifier string. It can be used to restore `BKBrowser` from `NSUserDefaults`.
 
 @param identifier The identifier string from which browser have to be restored.
 
 @return Browser. If identifier is not supported, `BKBrowserSafari` will be returned.
 */
BKBrowser BKBrowserFromIdentifier(NSString *identifier) NS_REFINED_FOR_SWIFT;


/**
 Returns name of the specified browser.
 
 @param browser The browser for which name is required.
 
 @return Browser name. For example `Opera Mini`.
 */
NSString *BKBrowserGetName(BKBrowser browser) NS_REFINED_FOR_SWIFT;


/**
 Returns thumbnail image for the specified browser.
 
 @param browser The browser for which thumbnail image is required.
 
 @return Browser thumbnail image. `nil` if browser is `BKBrowserInAppSafari`, image of size 100x100 otherwise
 */
UIImage * _Nullable BKBrowserGetThumbnail(BKBrowser browser) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_END
