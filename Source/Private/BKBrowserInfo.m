//
//  BKBrowserInfo.m
//  CustomBrowserKit
//
//  Created by KY1VSTAR on 25.03.18.
//

#import "BKBrowserInfo.h"
#import "BKBrowser.h"

static NSDictionary *browsersInfo;

@interface BKBrowserInfo ()

@property (nonatomic) NSArray *URLSchemes;
@property (nonatomic) BOOL shouldUseStringFormat;
@property (nonatomic) NSArray *URLs;
@property (nonatomic, readwrite) NSString *identifier;
@property (nonatomic, readwrite) NSString *name;

@end

@implementation BKBrowserInfo

+ (void)load {
    browsersInfo =
    @{
      @(BKBrowserChrome): [BKBrowserInfo infoWithIdentifier:@"chrome"
                                                       name:@"Google Chrome"
                                                 URLSchemes:@[@"googlechrome", @"googlechromes"]],
      
      @(BKBrowserFirefox): [BKBrowserInfo infoWithIdentifier:@"firefox"
                                                        name:@"Firefox"
                                                  URLSchemes:@[@"firefox://open-url?url=%@"]],
      
      @(BKBrowserOpera): [BKBrowserInfo infoWithIdentifier:@"opera"
                                                      name:@"Opera Mini"
                                                URLSchemes:@[@"opera-http://%@"]],
      
      @(BKBrowserUCBrowser): [BKBrowserInfo infoWithIdentifier:@"ucBrowser"
                                                          name:@"UC Browser"
                                                    URLSchemes:@[@"ucbrowser"]],
      
      @(BKBrowserPuffin): [BKBrowserInfo infoWithIdentifier:@"puffin"
                                                       name:@"Puffin Web Browser"
                                                 URLSchemes:@[@"puffin", @"puffins"]],
      
      @(BKBrowserYandexBrowser): [BKBrowserInfo infoWithIdentifier:@"yandexBrowser"
                                                              name:@"Yandex Browser"
                                                        URLSchemes:@[@"yandexbrowser-open-url://%@"]],
      
      };
}

+ (instancetype)infoWithIdentifier:(NSString *)identifier name:(NSString *)name URLSchemes:(NSArray *)URLSchemes {
    BKBrowserInfo *browserInfo = [[BKBrowserInfo alloc] init];
    browserInfo.URLSchemes = URLSchemes;
    BOOL shouldUseStringFormat = [URLSchemes[0] rangeOfString:@"%@"].location != NSNotFound;
    browserInfo.shouldUseStringFormat = shouldUseStringFormat;
    
    NSMutableArray *URLs = [NSMutableArray array];
    for (NSString *urlScheme in URLSchemes) {
        NSString *urlString;
        if (shouldUseStringFormat)
            urlString = [NSString stringWithFormat:urlScheme, @""];
        else
            urlString = [NSString stringWithFormat:@"%@://", urlScheme];
        [URLs addObject:[NSURL URLWithString:urlString]];
    }
    browserInfo.URLs = URLs;
    
    browserInfo.identifier = identifier;
    browserInfo.name = name;
    
    return browserInfo;
}

+ (BKBrowserInfo *)browserInfoForBrowser:(BKBrowser)browser {
    return browsersInfo[@(browser)];
}

- (NSString *)escapeURL:(NSURL *)url {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]<>\"{}"].invertedSet;
    NSString *str = [url.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:set] ?: @"";
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (BOOL)available {
    for (NSURL *url in self.URLs)
        if (![UIApplication.sharedApplication canOpenURL:url])
            return NO;
    return YES;
}

- (NSURL *)formattedURLFromURL:(NSURL *)url {
    if (self.shouldUseStringFormat)
        return [NSURL URLWithString:[NSString stringWithFormat:self.URLSchemes[0], [self escapeURL:url]]];
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    components.scheme = (self.URLSchemes.count == 1 || [components.scheme isEqualToString:@"http"]) ? self.URLSchemes[0] : self.URLSchemes[1];
    return components.URL;
}

@end
