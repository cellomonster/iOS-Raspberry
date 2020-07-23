//
//  RBServerStore.h
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCGuild;
@class RBGatewayEvent;
@class DCChannel;

@interface RBGuildStore : NSObject

-(void)storeReadyEvent:(RBGatewayEvent*)event;

-(void)addGuild:(DCGuild*)guild;
//-(void)removeGuildBySnowflake:(NSString*)snowflake;

-(DCGuild*)guildAtIndex:(int)index;
-(DCGuild*)guildOfSnowflake:(NSString*)snowflake;

-(DCChannel*)channelOfSnowflake:(NSString*)snowflake;

-(int) count;

@end
