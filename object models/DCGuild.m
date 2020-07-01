//
//  DCGuild.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCGuild.h"
#import "DCChannel.h"
#import "DCRole.h"

@implementation DCGuild
@synthesize snowflake = _snowflake;

-(DCGuild*)initFromDictionary:(NSDictionary *)dict{
	self = [super init];
	
	self.snowflake = [dict objectForKey:@"id"];
	
	self.name = [dict objectForKey:@"name"];
    
    self.sortingPosition = [[dict objectForKey:@"position"] intValue];
	
	NSLog(@"%@ - %d", self.name, self.sortingPosition);
	
    
	//Channels
	NSArray *jsonChannels = ((NSArray*)[dict objectForKey:@"channels"]);
	self.channels = [[NSMutableDictionary alloc] initWithCapacity:jsonChannels.count];
	for(NSDictionary *jsonChannel in jsonChannels){
		DCChannel *channel = [[DCChannel alloc] initFromDictionary:jsonChannel];
        if(channel.channelType == DCChannelTypeGuildText || channel.channelType == DCChannelTypeDirectMessage || channel.channelType == DCChannelTypeGroupMessage)
            [self.channels setObject:channel forKey:channel.snowflake];
	}
    
    
    self.sortedChannels = [[self.channels allValues] sortedArrayUsingComparator:^(DCChannel* c1, DCChannel* c2) {
        
        if (c1.sortingPosition > c2.sortingPosition) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (c1.sortingPosition < c2.sortingPosition) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    //NSLog(@"%@", [dict objectForKey:@"members"]);
	
	//Roles
	/* NSArray *jsonRoles = ((NSArray*)[dict objectForKey:@"roles"]);
     self.roles = [[NSMutableDictionary alloc] init];
     for(NSDictionary *jsonRole in jsonRoles){
     DCRole *role = [[DCRole alloc] initFromDictionary:jsonRole];
     [self.channels setObject:role forKey:role.snowflake];
     }*/
	
	return self;
}

@end
