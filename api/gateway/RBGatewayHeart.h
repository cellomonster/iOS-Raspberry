//
//  RBHeartbeat.h
//  raspberry
//
//  Created by Trevir on 4/20/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBWebSocket.h"

@interface RBGatewayHeart : NSObject

- (void)beginBeating:(int)everyMilliseconds throughWebsocket:(RBWebSocket*)websocket withSequenceNumber:(int*)sequenceNumber;
- (void)endHeartbeat;

@property bool didRecieveResponse;
@property int *sequenceNumber;

@end
