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

- (RBClient *)init {
	
	self = [super init];
	
	self.guildStore = [[RBGuildStore alloc] init];
    self.userStore = [[RBUserStore alloc] init];
    
	self.webSocketDelegate = [[RBWebSocketDelegate alloc] initWithGuildStore:self.guildStore];
	
	[self.webSocket setDelegate:self.webSocketDelegate];
	
	return self;
}

- (void)connectWithTokenString:(NSString*)tokenString {
	self.tokenString = tokenString;
    
    NSString *path = [NSBundle.mainBundle pathForResource: @"API Settings" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
	NSString* gatewayAddress = (NSString*)dict[@"gateway address"];
	
	if(!gatewayAddress)
		NSLog(@"!no gateway address found!");
	
	NSURL *url = [NSURL URLWithString:gatewayAddress];
    
    self.webSocket = [[RBWebSocket alloc] initWithURL:url];
    self.webSocket.delegate = self.webSocketDelegate;
    [self.webSocket open];
}

- (void)resumeWithSequenceNumber:(int)seqNum{
    
}

- (void)endSession{
    [self.webSocket close];
}

- (void)setLoginDelegate:(id<RBLoginDelegate>)delegate {
	[self.webSocketDelegate setLoginDelegate:delegate];
}

- (void)setMessageDelegate:(id <RBMessageDelegate>)delegate {
    [self.webSocketDelegate setMessageDelegate:delegate];
}

@end
