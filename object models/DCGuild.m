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

-(DCGuild*)initFromDictionary:(NSDictionary *)dict{
	self = [super init];
	
	if(![dict objectForKey:@"icon"]){
		[NSException exceptionWithName:@"invalid dictionary"
														reason:@"tried to initialize guild from invalid dictionary!"
													userInfo:dict];
	}
	
	self.snowflake = [dict objectForKey:@"id"];
	
	self.name = [dict objectForKey:@"name"];
	
	NSLog(@"%@", self.name);
	
	//Channels
	NSArray *jsonChannels = ((NSArray*)[dict objectForKey:@"channels"]);
	self.channels = [[NSMutableDictionary alloc] init];
	for(NSDictionary *jsonChannel in jsonChannels){
		DCChannel *channel = [[DCChannel alloc] initFromDictionary:jsonChannel];
		[self.channels setObject:channel forKey:channel.snowflake];
	}
	
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
