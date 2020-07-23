//
//  DCWebSocketDelegate.h
//  Disco
//
//  Created by Trevir on 3/23/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@class DCUser;
@class RBGuildStore;
@class RBUserStore;
@class DCChannel;

@interface RBWebSocketDelegate : NSObject <SRWebSocketDelegate>

@property RBGuildStore *guildStore;
@property RBUserStore *userStore;

-(RBWebSocketDelegate*)initWithGuildStore:(RBGuildStore*)guildStore andUserStore:(RBUserStore*)userStore;

@end
