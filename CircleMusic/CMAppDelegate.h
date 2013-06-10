//
//  CMAppDelegate.h
//  CircleMusic
//
//  Created by Kawasaki Toshiya on 5/5/13.
//  Copyright (c) 2013 FORCECLESS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPlayerViewController.h"

@class CMViewController;

@interface CMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;
@property (strong,nonatomic) CMPlayerViewController *playerViewController;
@property (atomic,assign) int iOStype;

@end
