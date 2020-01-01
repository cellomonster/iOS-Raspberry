//
//  RBClient.h
//  raspberry
//
//  Created by Trevir on 3/24/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUser.h"
#import "RBGuildStore.h"
#import "RBWebSocket.h"
#import "RBLoginDelegate.h"
#import "RBMessageDelegate.h"
#import "RBUserStore.h"

@interface RBClient: NSObject

@property (strong, nonatomic) RBGuildStore *guildStore;
@property (strong, nonatomic) RBUserStore *userStore;
@property (strong, nonatomic) RBWebSocket *webSocket;
@property (strong, nonatomic) NSString *tokenString;

- (RBClient *)init;
- (void)connectWithTokenString:(NSString*)tokenString;

- (void)endSession;

- (void)setLoginDelegate:(id <RBLoginDelegate>)delegate;
- (void)setMessageDelegate:(id <RBMessageDelegate>)delegate;

+ (RBClient *)sharedInstance;

@end
