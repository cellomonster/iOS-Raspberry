//
//  RBServerStore.m
//  raspberry
//
//  Created by Trevir on 5/31/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "RBGuildStore.h"
#import "DCChannel.h"

@interface RBGuildStore()

@property NSMutableDictionary* guildDictionary;
@property NSMutableArray* guildKeys;
@property NSMutableDictionary* channelDictionary;

@end

@implementation RBGuildStore

-(void)storeReadyEvent:(RBGatewayEvent*)event {
	if(![event.t isEqualToString:@"READY"]){
		NSLog(@"event %i isn't a ready event!", event.s);
		return;
	}
	
	self.guildDictionary = [NSMutableDictionary new];
    self.channelDictionary = [NSMutableDictionary new];
	
	NSArray* jsonGuilds = [[NSArray alloc] initWithArray:[event.d objectForKey:@"guilds"]];
	
	for(NSDictionary* jsonGuild in jsonGuilds){
		DCGuild* guild = [[DCGuild alloc]initFromDictionary:jsonGuild];
		[self.guildDictionary setObject:guild forKey:guild.snowflake];
        
        [self.channelDictionary addEntriesFromDictionary:guild.channels];
	}
    
    self.guildKeys = [[NSMutableArray alloc] initWithCapacity:self.guildDictionary.count];
    //self.guildKeys[0] =
    self.guildKeys = [[event.d objectForKey:@"user_settings"] objectForKey:@"guild_positions"];
    NSLog(@"%@", self.guildKeys);
}

-(void)addGuild:(DCGuild *)guild{
    [self.guildDictionary setObject:guild forKey:guild.snowflake];
}

-(DCGuild*)guildAtIndex:(int)index{
    NSString* key = self.guildKeys[index];
	return [self.guildDictionary objectForKey:key];
}

-(DCGuild*)guildOfSnowflake:(NSString *)snowflake{
    return [self.guildDictionary objectForKey:snowflake];
}

-(DCChannel*)channelOfSnowflake:(NSString *)snowflake{
    return [self.channelDictionary objectForKey:snowflake];
}

-(int)count{
	return self.guildDictionary.count;
}

@end
