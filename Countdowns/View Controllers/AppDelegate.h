//
//  AppDelegate.h
//  Countdowns
//
//  Created by raxod502 on 6/2/13.
//  Copyright (c) 2013 Raxod502. All rights reserved.
//

@class CountupDetailViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property NSTimer *timer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidEnterBackground:(UIApplication *)application;

+ (void)initialize;

@end
