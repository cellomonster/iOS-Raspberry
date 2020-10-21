//
//  RBAppDelegate.m
//  raspberry
//
//  Created by Trevir on 3/24/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBAppDelegate.h"
#import "RBClient.h"
#import "RBGuildStore.h"

@implementation RBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:45.0/255.0 green:54.0/255.0 blue:85.0/255.0 alpha:1.0]];
    
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if(RBClient.sharedInstance.presentSession)
        [RBClient.sharedInstance newSessionWithTokenString:RBClient.sharedInstance.tokenString shouldResume:true];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
