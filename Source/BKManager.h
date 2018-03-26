//
//  BKManager.h
//  CustomBrowserKit
//
//  Created by ky1vstar on 03/25/2018.
//  Copyright (c) 2018 ky1vstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BKBrowser);

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_subclassing_restricted))
@interface BKManager : NSObject

/**
 An array of currently installed and available browsers.
 
 @see -isBrowserAvailable:
 
 @warning The value of `BKBrowser` is wrapped in `NSNumber`. Use `NSNumber.intValue` to unwrap it.
 */
@property (class, nonatomic, readonly) NSArray<NSNumber *> *availableBrowsers NS_REFINED_FOR_SWIFT;

- (instancetype)init NS_UNAVAILABLE;


/**
 Checks if `BKManager` can open URLs in specified browser.
 
 @param browser The browser for which check is required.
 
 @return YES if browser is installed and `BKManager` can open URLs in it.
 */
+ (BOOL)isBrowserAvailable:(BKBrowser)browser;


/**
 Opens URL in specified browser. If it fails, `BKManager` will try to open URL in `fallbackBrowser`.
 
 @param url The URL to open.
 @param browser The primary browser in which URL should be opened.
 @param fallbackBrowser The reserve browser in which URL should be opened if it fails to be opened in primary one.
 
 @return NO if URL failed to be opened both in `browser` and `fallbackBrowser`.
 */
+ (BOOL)openURL:(NSURL *)url withBrowser:(BKBrowser)browser fallbackToBrowser:(BKBrowser)fallbackBrowser;


/**
 Opens URL in specified browser.
 
 @param url The URL to open.
 @param browser The browser in which URL should be opened.
 
 @return NO if URL failed to be opened.
 */
+ (BOOL)openURL:(NSURL *)url withBrowser:(BKBrowser)browser;

@end

NS_ASSUME_NONNULL_END
