//
//  RBClient.m
//  raspberry
//
//  Created by Trevir on 3/24/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBClient.h"
#import "RBWebSocket.h"
#import "RBWebSocketDelegate.h"
#import "RBGuildStore.h"
#import "RBUserStore.h"
#import "RBGatewayEvent.h"

@interface RBClient ()

@property (strong, nonatomic) RBWebSocketDelegate *webSocketDelegate;

@end

@implementation RBClient

+ (RBClient *)sharedInstance {
	static RBClient *sharedInstance = nil;
	static dispatch_once_t onceToken; // onceToken = 0
	dispatch_once(&onceToken, ^{
		sharedInstance = [[RBClient alloc] init];
	});
	
	return sharedInstance;
}

- (void)newSessionWithTokenString:(NSString*)tokenString shouldResume:(bool)shouldResume {
    
    if(self.presentSession)
        [self endSession];
    
    if(!shouldResume){
        self.guildStore = [[RBGuildStore alloc] init];
        self.userStore = [[RBUserStore alloc] init];
        
        self.webSocketDelegate = [[RBWebSocketDelegate alloc] initWithGuildStore:self.guildStore andUserStore:self.userStore];
        
        [self.webSocket setDelegate:self.webSocketDelegate];
    }
    
    NSLog(@"began new session with token %@", tokenString);
    
	self.tokenString = [tokenString stringByReplacingOccurrencesOfString:@"\"" withString:@""];;
    
    NSString *path = [NSBundle.mainBundle pathForResource: @"API Settings" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
	NSString* gatewayAddress = (NSString*)dict[@"gateway address"];
	
	if(!gatewayAddress)
		NSLog(@"!no gateway address found!");
	
	NSURL *url = [NSURL URLWithString:gatewayAddress];
    
    self.webSocketDelegate.shouldSendResumeOnHello = shouldResume;
    self.webSocket = [[RBWebSocket alloc] initWithURL:url];
    self.webSocket.delegate = self.webSocketDelegate;
    [self.webSocket open];
    
    self.presentSession = true;
}

- (void)endSession{
    [self.webSocket close];
    self.presentSession = false;
}

@end
