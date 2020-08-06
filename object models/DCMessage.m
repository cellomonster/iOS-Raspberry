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
#import "RBUserStore.h"
#import "RBGuildStore.h"
#import "DCUser.h"

@implementation DCMessage
@synthesize snowflake = _snowflake;
@synthesize author = _author;
@synthesize timestamp = _timestamp;
@synthesize member = _member;
@synthesize writtenByUser = _writtenByUser;

- (DCMessage *)initFromDictionary:(NSDictionary *)dict {
	self = [super init];
    
    if(![dict objectForKey:@"channel_id"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize message from invalid dictionary!"
                              userInfo:dict];
	}
    
	self.snowflake = [dict objectForKey:@"id"];
    
    self.type = (NSInteger)[dict objectForKey:@"type"];
	
	self.author = [RBClient.sharedInstance.userStore getUserBySnowflake:[[dict objectForKey:@"author"] objectForKey:@"id"]];
    if(self.author == RBClient.sharedInstance.user){
        self.writtenByUser = true;
    }else if(!self.author) {
        self.author = [[DCUser alloc] initFromDictionary:[dict objectForKey:@"author"]];
        [RBClient.sharedInstance.userStore addUser:self.author];
    }
    self.content = [dict objectForKey:@"content"];
    
    self.parentGuild = [RBClient.sharedInstance.guildStore guildOfSnowflake:[dict objectForKey:@"guild_id"]];
    self.parentChannel = [RBClient.sharedInstance.guildStore channelOfSnowflake:[dict objectForKey:@"channel_id"]];
    
#warning need to fix date parsing!
    
    //FORMAT: 2020-01-03T15:46:52.158000+00:00
//    
//    NSDateFormatter *dateFormat = [NSDateFormatter new];
//    [dateFormat setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss"];
//    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
//    [dateFormat setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [dateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
//    
//    NSString *dateString = [dict objectForKey:@"timestamp"];
//    self.timestamp = [dateFormat dateFromString:dateString];
//    
//    NSLog(@"%@", [dateFormat dateFromString:dateString]);
    
    
    NSArray *jsonAttachments = (NSArray*)([dict objectForKey:@"attachments"]);
    self.attachments = [[NSMutableDictionary alloc] initWithCapacity:jsonAttachments.count];
    
    for(NSDictionary *jsonAttachment in jsonAttachments){
        DCMessageAttatchment *messageAttachment = [[DCMessageAttatchment alloc] initFromDictionary:jsonAttachment withParentMessage:self];
        [self.attachments setObject:messageAttachment forKey:messageAttachment.snowflake];
    }
	
	return self;
}

-(void)queueLoadAttachments{
    for(DCMessageAttatchment *messageAttachment in [self.attachments allValues]){
        [messageAttachment queueLoadImage];
    }
}

@end
