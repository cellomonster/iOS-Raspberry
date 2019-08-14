//
//  DCWebSocketDelegate.m
//  Disco
//
//  Created by Trevir on 3/23/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBWebSocketDelegate.h"
#import "RBClient.h"
#import "RBGatewayEvent.h"
#import "RBGatewayHeart.h"
#import "RBCommon.h"

@interface RBWebSocketDelegate () <SRWebSocketDelegate>

@property RBGatewayHeart *heart;
@property int sequenceNumber;

@end

@implementation RBWebSocketDelegate

- (RBWebSocketDelegate*)initWithGuildStore:(RBGuildStore *)guildStore	{
	self = [super init];
	self.guildStore = guildStore;
	return self;
}

- (void)webSocket:(RBWebSocket *)webSocket didReceiveMessage:(id)message {
	RBGatewayEvent *event = [[RBGatewayEvent alloc] initWithJsonString:message];
	
	if(event){
		switch (event.op) {
			case RBGatewayEventTypeDispatch:
				NSLog(@"recieved dispatch %@, %i", event.t, event.s);
				[self setSequenceNumber:event.s];
				[self handleDispatchEvent:event withWebSocket:webSocket];
				break;
				
			case RBGatewayEventTypeHeartbeat:
				NSLog(@"recieved heartbeat");
				break;
				
			case RBGatewayEventTypeReconnect:
				NSLog(@"recieved reconnect order");
				break;
				
			case RBGatewayEventTypeInvalidSession:
				NSLog(@"recieved invalid session");
				break;
				
			case RBGatewayEventTypeHello:
				NSLog(@"recieved hello");
				[self handleHelloEvent:event withWebSocket:webSocket];
				break;
				
			case RBGatewayEventTypeHeartbeatAck:
				NSLog(@"recieved heartbeat ack");
				[self.heart setDidRecieveResponse:true];
				
				break;
				
			default:
				
				NSLog(@"!recieved unexpected opcode (%i)!", event.op);
				
				break;
		}
	}
}


-(void)handleDispatchEvent:(RBGatewayEvent *)event withWebSocket:(RBWebSocket *)webSocket {
	//make sure 'event' is the right type of event
	if(event.op != RBGatewayEventTypeDispatch) {
		NSLog(@"tried handling non-dispatch event %i as dispatch event!", event.s);
		return;
	}
	
	int index = [@[@"READY"] indexOfObject:event.t];

	switch (index) {
		case 0:
			[self.loginDelegate didLogin];
			self.guildStore = [self.guildStore storeReadyEvent:event];
			break;
			
		defualt:
			NSLog(@"unrecognized dispatch type on event %i!", event.s);
			break;
	}
}


-(void)handleHelloEvent:(RBGatewayEvent *)event withWebSocket:(RBWebSocket *)webSocket {
	//make sure 'event' is the right type of event
	if(event.op != RBGatewayEventTypeHello) {
		NSLog(@"tried handling non-hello event %i as hello event!", event.s);
		return;
	}
	
	//Begin heartbeat
	self.heart = [RBGatewayHeart new];
	[self.heart beginBeating:[event.d[@"heartbeat_interval"] intValue] throughWebsocket:webSocket withSequenceNumber:&_sequenceNumber];
	
	/*NSString *path = [[NSBundle mainBundle] pathForResource: @"Client Settings" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
	
	id token = dict[@"token"];*/
	
	
#warning Non-explicit dependency due to singleton!!
	id token = [RBClient sharedInstance].tokenString;
	
	//identify
	if([token isKindOfClass:NSString.class]){
		NSDictionary *dict = 
		@{
			@"token": (NSString*)token,
			@"properties": @{
				@"$browser": @"raspberry",
			},
	 };
		
		RBGatewayEvent *identifyEvent = [[RBGatewayEvent alloc] initWithEventType:RBGatewayEventTypeIdentify withDictionary:dict];
		
		[webSocket sendGatewayEvent:identifyEvent];
		NSLog(@"sent identify");
	}
}

@end
