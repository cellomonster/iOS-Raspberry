//
//  RBServerStore.h
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCGuild.h"
#import "RBGatewayEvent.h"

@interface RBGuildStore : NSObject

-(RBGuildStore*)storeReadyEvent:(RBGatewayEvent*)event;

-(void)addGuild:(DCGuild*)guild;
-(void)removeGuildBySnowflake:(NSString*)snowflake;
-(DCGuild*)guildAtIndex:(int)index;

-(int) count;

@end
