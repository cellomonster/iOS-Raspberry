//
//  RBGatewayEvent.h
//  raspberry
//
//  Created by Trevir on 4/20/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RBGatewayEventType) {
	RBGatewayEventTypeDispatch,
	RBGatewayEventTypeHeartbeat,
	RBGatewayEventTypeIdentify,
	RBGatewayEventTypeStatusUpdate,
	RBGatewayEventTypeVoiceStateUpdate,
	RBGatewayEventTypeResume = 6, //discord where the fuck is opcode 5?!
	RBGatewayEventTypeReconnect,
	RBGatewayEventTypeRequestGuildMembers,
	RBGatewayEventTypeInvalidSession,
	RBGatewayEventTypeHello,
	RBGatewayEventTypeHeartbeatAck,
};

@interface RBGatewayEvent : NSObject

@property RBGatewayEventType op;
@property int s;
@property NSDictionary *d;
@property NSString *t;

//- (NSString *)toJsonString;
- (RBGatewayEvent *)initWithJsonString:(NSString *)json;
- (RBGatewayEvent *)initWithEventType:(RBGatewayEventType)type withDictionary:(NSDictionary *)dict;
- (NSString *)description;

@end
