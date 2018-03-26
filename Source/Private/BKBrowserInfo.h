//
//  BKBrowserInfo.h
//  CustomBrowserKit
//
//  Created by KY1VSTAR on 25.03.18.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BKBrowser);

NS_ASSUME_NONNULL_BEGIN

/**
 Additional info for `BKBrowser`. Internal class.
 */
@interface BKBrowserInfo : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) BOOL available;

+ (BKBrowserInfo *)browserInfoForBrowser:(BKBrowser)browser;
- (NSURL *)formattedURLFromURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
