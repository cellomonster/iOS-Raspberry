//
//  RBGatewayEvent.m
//  raspberry
//
//  Created by Trevir on 4/20/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBGatewayEvent.h"
#import "RBCommon.h"

@implementation RBGatewayEvent

- (RBGatewayEvent *)initWithJsonString:(NSString *)json {
	
	self = [super init];
	
	NSDictionary *parsedJson = [RBCommon parseJSON:json];
	
	if(parsedJson[@"op"]){
		self.op = [parsedJson[@"op"] intValue];
		self.d = (NSDictionary*)parsedJson[@"d"];
		
		if(self.op == RBGatewayEventTypeDispatch){
			self.s = [parsedJson[@"s"] intValue];
			self.t = (NSString*)parsedJson[@"t"];
		}
	}else{
		NSLog(@"tried to initialize an event with invalid JSON!");
	}
	
	return self;
}

- (RBGatewayEvent *)initWithEventType:(RBGatewayEventType)type withDictionary:(NSDictionary *)dict {
	self = [super init];
	self.op = type;
	self.d = dict;
	
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"opcode: %i\n%@", self.op, self.d];
}

@end
