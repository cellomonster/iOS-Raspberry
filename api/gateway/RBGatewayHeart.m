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
@property NSTimer *heartbeatTimer;

@end

@implementation RBGatewayHeart

- (void)beginBeating:(int)everyMilliseconds throughWebsocket:(RBWebSocket*)websocket withSequenceNumber:(int*)sequenceNumber {
	self.websocket = websocket;
	self.sequenceNumber = sequenceNumber;
	self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:everyMilliseconds / 1000.0f
																	 target:self
																 selector:@selector(sendHeartbeat:)
																 userInfo:nil
																	repeats:YES];
    
    self.lastHeartbeatInterval = everyMilliseconds;
	
	NSLog(@"began heartbeat every %f seconds", everyMilliseconds / 1000.0f);
}

- (void)endHeartbeat{
    if(self.heartbeatTimer.isValid)
        [self.heartbeatTimer invalidate];
}

- (void)sendHeartbeat:(NSTimer *)timer{
	if(!self.didRecieveResponse){
        NSLog(@"failed to recieve heartbeat ack!");
        [self endHeartbeat];
        [RBClient.sharedInstance newSessionWithTokenString:RBClient.sharedInstance.tokenString shouldResume:true];
    }
    
	NSDictionary *json =
	@{
      @"op": @1,
      @"d": @(*(self.sequenceNumber))
	 };
	
	[self.websocket sendDictionary:json];
	[self setDidRecieveResponse:false];
	
	NSLog(@"sent heartbeat %i", *(self.sequenceNumber));
}

@end
