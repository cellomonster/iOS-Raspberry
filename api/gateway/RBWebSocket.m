//
//  RBWebSocket.m
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBWebSocket.h"
#import "RBGatewayEvent.h"

@implementation RBWebSocket

-(void)sendDictionary:(NSDictionary*)dict{
	NSError *error;
	
	NSData *data = [NSJSONSerialization dataWithJSONObject:dict
																								 options:NSJSONWritingPrettyPrinted
																									 error:&error];
	
	//NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	
	[self send:data];
}

-(void)sendGatewayEvent:(RBGatewayEvent*)event{
	NSDictionary *dict =
	@{
		@"op":@((int)event.op),
		@"d":event.d
	};
	
	[self sendDictionary:dict];
}

- (void)open {
	if(!self.isOpen) {
		self.isOpen = true;
		[super open];
		NSLog(@"opened websocket");
	} else NSLog(@"?websocket is already open?");
}

- (void)close {
	if(self.isOpen) {
		self.isOpen = false;
		[super close];
		NSLog(@"closed websocket");
	} else NSLog(@"?websocket is already closed?");
}

@end
