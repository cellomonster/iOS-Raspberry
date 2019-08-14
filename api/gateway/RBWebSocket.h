//
//  RBWebSocket.h
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "SRWebSocket.h"
#import "RBGatewayEvent.h"

@interface RBWebSocket : SRWebSocket

@property BOOL isOpen;

-(void)sendDictionary:(NSDictionary *)dict;
-(void)sendGatewayEvent:(RBGatewayEvent *)event;
-(void)open;
-(void)close;

@end
