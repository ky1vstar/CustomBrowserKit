//
//  ObjectiveCViewController.m
//  CustomBrowserKit_Example
//
//  Created by KY1VSTAR on 26.03.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "ObjectiveCViewController.h"
@import CustomBrowserKit;

@interface ObjectiveCViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) IBOutlet UIBarButtonItem *goBarButtonItem;
@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *availableBrowsers;
@property (nonatomic) BKBrowser selectedBrowser;
@property (nonatomic) NSURL *currentURL;

@end

@implementation ObjectiveCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.availableBrowsers = BKManager.availableBrowsers;
    self.selectedBrowser = BKBrowserSafari;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self textFieldDidChange];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (UIImage *)resizeImage:(UIImage *)image toNewSize:(CGSize)newSize {
    if (!image) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - TextField

- (IBAction)textFieldDidChange {
    if (self.textField.text.length != 0 && (self.currentURL = [NSURL URLWithString:self.textField.text])) {
        self.goBarButtonItem.enabled = YES;
    } else {
        self.goBarButtonItem.enabled = NO;
    }
}

#pragma mark - Button

- (IBAction)goButtonClicked {
    [self.textField endEditing:YES];
    
    if ([BKManager openURL:self.currentURL withBrowser:self.selectedBrowser]) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to open URL" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    [self handleKeyboardNotification:notification willShow:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self handleKeyboardNotification:notification willShow:NO];
}

- (void)handleKeyboardNotification:(NSNotification *)notification willShow:(BOOL)willShow {
    CGFloat keyboardHeight = willShow ? [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height : 0;
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    
    UIEdgeInsets finalContentInset = self.tableView.contentInset;
    finalContentInset.bottom = keyboardHeight;
    
    UIEdgeInsets finalScrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
    finalScrollIndicatorInsets.bottom = keyboardHeight;
    
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
        self.tableView.contentInset = finalContentInset;
        self.tableView.scrollIndicatorInsets = finalScrollIndicatorInsets;
    } completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSUInteger previouslySelectedBrowserIndex = [self.availableBrowsers indexOfObject:@(self.selectedBrowser)];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:previouslySelectedBrowserIndex inSection:0]];
    if (cell) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.selectedBrowser = [self.availableBrowsers[indexPath.row] integerValue];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableBrowsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKBrowser browser = [self.availableBrowsers[indexPath.row] integerValue];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.imageView.image = [self resizeImage:BKBrowserGetThumbnail(browser) toNewSize:CGSizeMake(32, 32)];
    cell.imageView.layer.cornerRadius = 32 * 0.157;
    cell.imageView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    cell.imageView.layer.borderWidth = 1 / UIScreen.mainScreen.scale;
    cell.imageView.clipsToBounds = YES;
    
    cell.textLabel.text = BKBrowserGetName(browser);
    
    cell.accessoryType = browser == self.selectedBrowser ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Browsers";
}

@end
