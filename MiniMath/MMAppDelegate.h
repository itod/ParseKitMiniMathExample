//
//  MMAppDelegate.h
//  MiniMath
//
//  Created by Todd Ditchendorf on 4/29/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMViewController;

@interface MMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MMViewController *viewController;

@end
