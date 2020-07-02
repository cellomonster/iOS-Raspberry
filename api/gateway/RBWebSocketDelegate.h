//
//  DCWebSocketDelegate.h
//  Disco
//
//  Created by Trevir on 3/23/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "RBLoginDelegate.h"
#import "RBMessageDelegate.h"

@class DCUser;
@class RBGuildStore;
@class RBUserStore;

@interface RBWebSocketDelegate : NSObject <SRWebSocketDelegate>

@property RBGuildStore *guildStore;
@property RBUserStore *userStore;
@property DCUser *user;
@property id <RBLoginDelegate> loginDelegate;
@property id <RBMessageDelegate> messageDelegate;

-(RBWebSocketDelegate*)initWithGuildStore:(RBGuildStore*)guildStore andUserStore:(RBUserStore*)userStore;

@end
