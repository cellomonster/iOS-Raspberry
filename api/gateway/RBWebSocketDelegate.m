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

@interface RBWebSocketDelegate () <SRWebSocketDelegate>

@property RBGatewayHeart *heart;
@property int sequenceNumber;
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
	
	if(event){
		switch (event.op) {
			case RBGatewayEventTypeDispatch:
				NSLog(@"recieved dispatch %@, %i", event.t, event.s);
				[self setSequenceNumber:event.s];
				[self handleDispatchEvent:event withWebSocket:webSocket];
				break;
				
			case RBGatewayEventTypeHeartbeat:
				NSLog(@"recieved heartbeat");
                if(!self.heart.didRecieveResponse){
                    
                }
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
	
	int index = [@[@"READY", @"MESSAGE_CREATE"] indexOfObject:event.t];

	switch (index) {
		case 0: {
			[self.loginDelegate didLogin];
            NSDictionary* userDict = [event.d objectForKey:@"user"];
            DCUser* user = [[DCUser alloc] initFromDictionary:userDict];
            [self.userStore addUser:user];
            self.userStore.clientUser = user;
			[self.guildStore storeReadyEvent:event];
            self.authenticated = true;
            
            //NSLog(@"%@", event.d);
        }
            break;
            
        case 1:
            if(self.messageDelegate){
                DCMessage* message = [[DCMessage alloc] initFromDictionary:event.d];
                [self.messageDelegate handleMessageCreate:message];
            }
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
    if(self.heart)
        [self.heart endHeartbeat];
	self.heart = [RBGatewayHeart new];
	[self.heart beginBeating:[event.d[@"heartbeat_interval"] intValue] throughWebsocket:webSocket withSequenceNumber:&_sequenceNumber];
	
	/*NSString *path = [[NSBundle mainBundle] pathForResource: @"Client Settings" ofType:@"plist"];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
	
	id token = dict[@"token"];*/
    
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
		
		[RBClient.sharedInstance.webSocket sendGatewayEvent:identifyEvent];
		NSLog(@"sent identify");
	}
}

@end
