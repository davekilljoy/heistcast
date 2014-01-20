//
//  AppDelegate.m
//  HeistCast
//
//  Created by David Stubbs on 1/15/2014.
//  Copyright (c) 2014 David Stubbs. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[application setStatusBarHidden:NO];
	[application setStatusBarStyle:UIStatusBarStyleLightContent];
	
	NSShadow *shadow = [NSShadow.alloc init];
	shadow.shadowColor = [UIColor blackColor];
	shadow.shadowOffset = CGSizeMake(0, 0);
	NSDictionary *titleAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:234/255.0f green:233/255.0f blue:225/255.0f alpha:1.0f],
									NSShadowAttributeName: shadow,
									NSFontAttributeName: [UIFont fontWithName:@"FreightSansMedium" size:20.0]};
	
	[[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
