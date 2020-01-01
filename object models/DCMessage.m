//
//  DCMessage.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCMessage.h"
#import "RBClient.h"
#import "DCMessageAttatchment.h"

@implementation DCMessage
@synthesize snowflake = _snowflake;
@synthesize author = _author;
@synthesize time = _time;
@synthesize member = _member;

- (DCMessage *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
    
	self.snowflake = [dict objectForKey:@"id"];
    
    self.type = (NSInteger)[dict objectForKey:@"type"];
	
	self.author = [RBClient.sharedInstance.userStore getUserBySnowflake:[[dict objectForKey:@"author"] objectForKey:@"id"]];
    if(!self.author) {
        self.author = [[DCUser alloc] initFromDictionary:[dict objectForKey:@"author"]];
        [RBClient.sharedInstance.userStore addUser:self.author];
    }
    self.content = [dict objectForKey:@"content"];
    
    self.parentGuild = [RBClient.sharedInstance.guildStore guildOfSnowflake:[dict objectForKey:@"guild_id"]];
    self.parentChannel = [RBClient.sharedInstance.guildStore channelOfSnowflake:[dict objectForKey:@"channel_id"]];
    
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    //correcting format to include seconds and decimal place
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Always use this locale when parsing fixed format date strings
    NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormat.locale = posix;
    self.timestamp = [dateFormat dateFromString:[dict objectForKey:@"timestamp"]];
    
    
    NSArray *jsonAttachments = (NSArray*)([dict objectForKey:@"attachments"]);
    self.attachments = [[NSMutableDictionary alloc] initWithCapacity:jsonAttachments.count];
    
    for(NSDictionary *jsonAttachment in jsonAttachments){
        DCMessageAttatchment *messageAttachment = [[DCMessageAttatchment alloc] initFromDictionary:jsonAttachment];
        messageAttachment.author = self.author;
        [self.attachments setObject:messageAttachment forKey:messageAttachment.snowflake];
    }
    

    //self.attachments = [dict objectForKey:@"attachments"];
    //self.embeds = [dict objectForKey:@"embeds"];
	
	return self;
}

@end
