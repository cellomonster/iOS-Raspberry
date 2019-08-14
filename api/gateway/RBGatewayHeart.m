//
//  RBHeartbeat.m
//  raspberry
//
//  Created by Trevir on 4/20/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBGatewayHeart.h"
#import "RBClient.h"

@interface RBGatewayHeart()

@property RBWebSocket *websocket;

@end

@implementation RBGatewayHeart

- (void)beginBeating:(int)everyMilliseconds throughWebsocket:(RBWebSocket*)websocket withSequenceNumber:(int*)sequenceNumber {
	self.websocket = websocket;
	self.sequenceNumber = sequenceNumber;
	[NSTimer scheduledTimerWithTimeInterval:everyMilliseconds / 1000.0f
																	 target:self
																 selector:@selector(sendHeartbeat:)
																 userInfo:nil
																	repeats:YES];
	
	NSLog(@"began heartbeat every %f seconds", everyMilliseconds / 1000.0f);
}

- (void)sendHeartbeat:(NSTimer *)timer{
	
	NSDictionary *json =
	@{@"op": @1,
	 @"d": @(*(self.sequenceNumber))
	 };
	
	[self.websocket sendDictionary:json];
	[self setDidRecieveResponse:false];
	
	NSLog(@"sent heartbeat %i", *(self.sequenceNumber));
}

@end
