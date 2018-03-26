//
//  BKBrowser.m
//  CustomBrowserKit
//
//  Created by ky1vstar on 03/25/2018.
//  Copyright (c) 2018 ky1vstar. All rights reserved.
//

#import "BKBrowser.h"
#import "BKManager.h"
#import "BKBrowserInfo.h"

static NSBundle *frameworkBundle() {
    static dispatch_once_t once;
    static NSBundle *bundle;
    dispatch_once(&once, ^{
        bundle = [NSBundle bundleForClass:[BKManager class]];
        NSLog(@"bundle: %@", bundle);
    });
    return bundle;
}

NSString *BKBrowserGetIdentifier(BKBrowser browser) {
    switch (browser) {
        case BKBrowserInAppSafari:
            return @"inAppSafari";
            
        case BKBrowserSafari:
            return @"safari";
            
        default:
            return [BKBrowserInfo browserInfoForBrowser:browser].identifier;
    }
}

BKBrowser BKBrowserFromIdentifier(NSString *identifier) {
    for (BKBrowser i = 0; i <= BKBrowserSafari; i++)
        if ([BKBrowserGetIdentifier(i) isEqualToString:identifier])
            return i;
    
    return BKBrowserSafari;
}

NSString *BKBrowserGetName(BKBrowser browser) {
    switch (browser) {
        case BKBrowserInAppSafari:
            return @"In-App Safari";
            
        case BKBrowserSafari:
            return @"Safari";
            
        default:
            return [BKBrowserInfo browserInfoForBrowser:browser].name;
    }
}

UIImage *BKBrowserGetThumbnail(BKBrowser browser) {
    return [UIImage imageNamed:BKBrowserGetIdentifier(browser) inBundle:frameworkBundle() compatibleWithTraitCollection:nil];
}
