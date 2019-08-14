//
//  RBServerStore.m
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBGuildStore.h"
@interface RBGuildStore()

@property NSMutableDictionary* guildDictionary;

@end

@implementation RBGuildStore

-(RBGuildStore*)storeReadyEvent:(RBGatewayEvent*)event {
	if(![event.t isEqualToString:@"READY"]){
		NSLog(@"event %iisn't a ready event!", event.s);
		return nil;
	}
	
	self.guildDictionary = [NSMutableDictionary new];
	
	NSArray* jsonGuilds = [[NSArray alloc] initWithArray:[event.d objectForKey:@"guilds"]];
	
	for(NSDictionary* jsonGuild in jsonGuilds){
		DCGuild* guild = [[DCGuild alloc]initFromDictionary:jsonGuild];
		[self.guildDictionary setObject:guild forKey:guild.snowflake];
	}
	
	return self;
}

-(DCGuild*)guildAtIndex:(int)index{
	NSArray *keys = [self.guildDictionary allKeys];
	return (DCGuild*)[self.guildDictionary objectForKey:keys[index]];
}

-(int)count{
	return self.guildDictionary.count;
}

@end
