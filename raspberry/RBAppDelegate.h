//
//  RBAppDelegate.h
//  raspberry
//
//  Created by Trevir on 3/24/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBClient.h"

@interface RBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) RBClient *client;

@end
