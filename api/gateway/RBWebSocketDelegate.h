//
//  DCWebSocketDelegate.h
//  Disco
//
//  Created by Trevir on 3/23/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "RBGuildStore.h"
#import "RBLoginDelegate.h"
#import "RBMessageDelegate.h"

@interface RBWebSocketDelegate : NSObject <SRWebSocketDelegate>

@property RBGuildStore *guildStore;
@property id <RBLoginDelegate> loginDelegate;
@property id <RBMessageDelegate> messageDelegate;

-(RBWebSocketDelegate*)initWithGuildStore:(RBGuildStore*)guildStore;

@end
