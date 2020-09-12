//
//  RBClient.h
//  raspberry
//
//  Created by Trevir on 3/24/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBGuildStore;
@class RBUserStore;
@class RBWebSocket;
@class DCUser;
@class DCChannel;

@interface RBClient: NSObject

@property (strong, nonatomic) RBGuildStore *guildStore;
@property (strong, nonatomic) RBUserStore *userStore;
@property (strong, nonatomic) RBWebSocket *webSocket;
@property (strong, nonatomic) NSString *tokenString;
@property (strong, nonatomic) DCUser *user;
@property bool presentSession;

- (RBClient *)init;

- (void)newSessionWithTokenString:(NSString*)tokenString shouldResume:(bool)shouldResume;
- (void)endSession;

+ (RBClient *)sharedInstance;

@end
