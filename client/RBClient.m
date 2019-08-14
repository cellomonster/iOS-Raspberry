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
	
	NSString *path = [NSBundle.mainBundle pathForResource: @"API Settings" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
	NSString* gatewayAddress = (NSString*)dict[@"gateway address"];
	
	if(!gatewayAddress)
		NSLog(@"!no gateway address found!");
	
	NSURL *url = [NSURL URLWithString:gatewayAddress];
	
	self.guildStore = [[RBGuildStore alloc] init];
	
	self.webSocket = [[RBWebSocket alloc] initWithURL:url];
	self.webSocketDelegate = [[RBWebSocketDelegate alloc] initWithGuildStore:self.guildStore];
	
	[self.webSocket setDelegate:self.webSocketDelegate];
	
	return self;
}

- (void)connect {
	[self.webSocket open];
}

- (void)connectWithTokenString:(NSString*)tokenString {
	self.tokenString = tokenString;
	[self.webSocket open];
}

- (void)setLoginDelegate:(id<RBLoginDelegate>)delegate {
	[self.webSocketDelegate setLoginDelegate:delegate];
}

@end
