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
#import "DCUser.h"
#import "RBGuildStore.h"
#import "RBUserStore.h"
#import "DCMessage.h"
#import "DCChannel.h"
#import "RBNotificationEvent.h"

@interface RBWebSocketDelegate () <SRWebSocketDelegate>

@property RBGatewayHeart *heart;
@property bool authenticated;

@end

@implementation RBWebSocketDelegate

- (RBWebSocketDelegate*)initWithGuildStore:(RBGuildStore *)guildStore andUserStore:(RBUserStore*)userStore {
	self = [super init];
	self.guildStore = guildStore;
    self.userStore = userStore;
    
	return self;
}

- (void)webSocket:(RBWebSocket *)webSocket didReceiveMessage:(id)message {
	RBGatewayEvent *event = [[RBGatewayEvent alloc] initWithJsonString:message];
	
    if(![event.t isEqualToString:@"READY"])
        NSLog(@"event data: %@, %i, %i, %@", event.t, event.s, event.op, event.d);
    
	if(event){
		switch (event.op) {
			case RBGatewayEventTypeDispatch:
				NSLog(@"recieved dispatch %@, %i", event.t, event.s);
				[self setSequenceNumber:event.s];
				[self handleDispatchEvent:event withWebSocket:webSocket];
				break;
				
			case RBGatewayEventTypeHeartbeat:
				NSLog(@"recieved heartbeat");
                self.heart.didRecieveResponse = true;
				break;
				
			case RBGatewayEventTypeReconnect:
				NSLog(@"recieved reconnect order");
                
                [RBClient.sharedInstance newSessionWithTokenString:RBClient.sharedInstance.tokenString shouldResume:false];
				break;
				
			case RBGatewayEventTypeInvalidSession:
				NSLog(@"recieved invalid session");
                
                [RBClient.sharedInstance newSessionWithTokenString:RBClient.sharedInstance.tokenString shouldResume:false];
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
		NSLog(@"tried handling non-dispatch event %i as dispatch event!", event.op);
		return;
	}
	
	int index = [@[@"READY", @"MESSAGE_CREATE", @"RESUMED"] indexOfObject:event.t];
    
	switch (index) {
		case 0: {
            
            self.sessionId = [event.d objectForKey:@"session_id"];
            
            NSDictionary* userDict = [event.d objectForKey:@"user"];
            DCUser* user = [[DCUser alloc] initFromDictionary:userDict];
            [self.userStore addUser:user];
            RBClient.sharedInstance.user = user;
            
			[self.guildStore handleReadyEvent:event];
            self.authenticated = true;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RBNotificationEventDidLogin object:event];
            
            [NSUserDefaults.standardUserDefaults setObject:RBClient.sharedInstance.tokenString forKey:@"last usable token"];
        }
            break;
            
        case 1: {
            
            DCMessage* message = [[DCMessage alloc] initFromDictionary:event.d];
            if(message.parentChannel != nil){
                [message.parentChannel handleNewMessage:message];
            }
            break;
        }
            
        case 2: {
            
            break;
        }
			
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
    if(self.heart)
        [self.heart endHeartbeat];
	self.heart = [RBGatewayHeart new];
	[self.heart beginBeating:[event.d[@"heartbeat_interval"] intValue] throughWebsocket:webSocket withSequenceNumber:&_sequenceNumber];
    self.heart.didRecieveResponse = true;
    
    RBGatewayEvent *eventToSend;
	
    if(self.shouldSendResumeOnHello){
        NSDictionary *dict =
        @{
          @"token": RBClient.sharedInstance.tokenString,
          @"session_id": self.sessionId,
          @"seq": @(self.sequenceNumber)
          };
        
        eventToSend = [[RBGatewayEvent alloc] initWithEventType:RBGatewayEventTypeResume withDictionary:dict];
    }else{
        //identify
        NSDictionary *dict =
        @{
          @"token": RBClient.sharedInstance.tokenString,
          @"properties": @{
                  @"$browser": @"raspberry",
                  },
          };
        
        eventToSend = [[RBGatewayEvent alloc] initWithEventType:RBGatewayEventTypeIdentify withDictionary:dict];
    }
    
    [RBClient.sharedInstance.webSocket sendGatewayEvent:eventToSend];
    NSLog(@"sent identify");
}

@end
