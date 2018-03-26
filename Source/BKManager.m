//
//  BKManager.m
//  CustomBrowserKit
//
//  Created by ky1vstar on 03/25/2018.
//  Copyright (c) 2018 ky1vstar. All rights reserved.
//

#import "BKManager.h"
#import "BKBrowser.h"
#import "BKBrowserInfo.h"
#import <SafariServices/SafariServices.h>

@implementation BKManager

+ (UIViewController *)topViewController {
    for (NSNumber *wrappedBrowser in BKManager.availableBrowsers) {
        BKBrowser browser = (BKBrowser)wrappedBrowser.intValue;
        NSLog(@"%@ is available", BKBrowserGetName(browser));
    }
    
    UIViewController *viewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (viewController.presentedViewController)
        viewController = viewController.presentedViewController;
    return viewController;
}

+ (NSArray *)availableBrowsers {
    NSMutableArray *availableBrowsers = [NSMutableArray array];
    
    for (BKBrowser i = 0; i <= BKBrowserSafari; i++)
        if ([self isBrowserAvailable:i])
            [availableBrowsers addObject:@(i)];
    
    return availableBrowsers;
}

+ (BOOL)isBrowserAvailable:(BKBrowser)browser {
    switch (browser) {
        case BKBrowserInAppSafari:
            if (@available(iOS 9.0, *))
                return YES;
            else
                return NO;
            
        case BKBrowserSafari:
            return YES;
            
        default:
            return [BKBrowserInfo browserInfoForBrowser:browser].available;
    }
}

+ (BOOL)openURL:(NSURL *)url withBrowser:(BKBrowser)browser fallbackToBrowser:(BKBrowser)fallbackBrowser {
    if ([self openURL:url withBrowser:browser])
        return YES;
    
    if (browser == fallbackBrowser)
        return NO;
    
    return [self openURL:url withBrowser:fallbackBrowser];
}

+ (BOOL)openURL:(NSURL *)url withBrowser:(BKBrowser)browser {
    if (![self isBrowserAvailable:browser])
        return NO;
    
    if (![url.scheme isEqualToString:@"http"] && ![url.scheme isEqualToString:@"https"] && browser != BKBrowserSafari)
        return NO;
    
    if (browser == BKBrowserInAppSafari) {
        if (@available(iOS 9.0, *)) {
            UIViewController *topViewController = [self topViewController];
            if (!topViewController)
                return NO;
            
            SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
            [topViewController presentViewController:svc animated:YES completion:nil];
            return YES;
        } else
            return NO;
        
    } else if (browser != BKBrowserSafari)
        url = [[BKBrowserInfo browserInfoForBrowser:browser] formattedURLFromURL:url];
    
    if (!url || ![UIApplication.sharedApplication canOpenURL:url])
        return NO;
    
    if (@available(iOS 10.0, *)) {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
    } else {
        [UIApplication.sharedApplication openURL:url];
    }
    
    return YES;
}

@end
