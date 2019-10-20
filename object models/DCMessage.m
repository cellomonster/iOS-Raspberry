//
//  DCMessage.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCMessage.h"
#import "RBClient.h"

@implementation DCMessage

- (DCMessage *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
	
	if(![dict objectForKey:@"author"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize message from invalid dictionary!"
                              userInfo:dict];
	}
	
	self.snowflake = [dict objectForKey:@"id"];
    
    self.type = (NSInteger)[dict objectForKey:@"type"];
	
	self.author = [[DCUser alloc]initFromDictionary:[dict objectForKey:@"author"]];
    self.content = [dict objectForKey:@"content"];
    
    self.parentGuild = [RBClient.sharedInstance.guildStore guildOfSnowflake:[dict objectForKey:@"guild_id"]];
    self.parentChannel = [RBClient.sharedInstance.guildStore channelOfSnowflake:[dict objectForKey:@"channel_id"]];
    

    //self.attachments = [dict objectForKey:@"attachments"];
    //self.embeds = [dict objectForKey:@"embeds"];
	
	return self;
}

@end
