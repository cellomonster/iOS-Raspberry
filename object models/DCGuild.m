//
//  DCGuild.m
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import "DCDiscordObject.h"
#import "DCGuildMember.h"
#import "DCGuild.h"
#import "DCChannel.h"
#import "DCRole.h"
#import "DCUser.h"

@implementation DCGuild
@synthesize snowflake = _snowflake;

-(DCGuild*)initFromDictionary:(NSDictionary *)dict{
	self = [super init];
    
    if(![dict objectForKey:@"region"]){
		[NSException exceptionWithName:@"invalid dictionary"
                                reason:@"tried to initialize guild from invalid dictionary!"
                              userInfo:dict];
	}
	
	self.snowflake = [dict objectForKey:@"id"];
	self.name = [dict objectForKey:@"name"];
    self.ownedByUser = [[dict objectForKey:@"owner"] boolValue];
    self.iconHash = [dict objectForKey:@"icon"];
    
    // Order in which objects must be initialized:
    // Roles, Guild members, and channels
	
    //Roles
    NSArray *jsonRoles = ((NSArray*)[dict objectForKey:@"roles"]);
    self.roles = [[NSMutableDictionary alloc]initWithCapacity:jsonRoles.count];

    for(NSDictionary* jsonRole in jsonRoles){
//        NSLog(@"%@", jsonRole);
        DCRole* role = [[DCRole alloc] initFromDictionary:jsonRole];
        [self.roles setObject:role forKey:role.snowflake];
        // todo move into initWithDictionary in role object
    }
    
    self.everyoneRole = [self.roles objectForKey:self.snowflake];
    
    //Guild members
    NSArray *jsonMembers = ((NSArray*)[dict objectForKey:@"members"]);
    self.members = [[NSMutableDictionary alloc] initWithCapacity:jsonMembers.count];
    for(NSDictionary *jsonMember in jsonMembers){
        DCGuildMember* member = [[DCGuildMember alloc]initFromDictionary:jsonMember inGuild:self];
        [self.members setObject:member forKey:member.user.snowflake];
    }
    
    [self.userGuildMember.roles setObject:self.everyoneRole forKey:self.everyoneRole.snowflake];
    
	//Channels
	NSArray *jsonChannels = ((NSArray*)[dict objectForKey:@"channels"]);
	self.channels = [[NSMutableDictionary alloc] initWithCapacity:jsonChannels.count];
	for(NSDictionary *jsonChannel in jsonChannels){
		DCChannel *channel = [[DCChannel alloc] initFromDictionary:jsonChannel andGuild:self];
        if((channel.channelType == DCChannelTypeGuildText || channel.channelType == DCChannelTypeDirectMessage || channel.channelType == DCChannelTypeGroupMessage) && channel.isVisible)
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
	
	return self;
}

-(DCGuild*)initAsDMGuildFromJsonPrivateChannels:(NSDictionary *)jsonPrivateChannels{
	self = [super init];
    
	self.name = @"DM Channel";
    self.snowflake = @"0";
    self.iconImage = [UIImage imageNamed:@"default"];
    
    // Order in which objects must be initialized:
    // Roles, Guild members, and channels
    
	//Channels
	self.channels = [[NSMutableDictionary alloc] initWithCapacity:jsonPrivateChannels.count];
	for(NSDictionary *jsonChannel in jsonPrivateChannels){
		DCChannel *channel = [[DCChannel alloc] initFromDictionary:jsonChannel andGuild:self];
        if(channel.channelType == DCChannelTypeDirectMessage)
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
	
	return self;
}


- (UIImage *)loadIconImage {
    NSString *imgURLstr = [NSString stringWithFormat:@"https://cdn.discordapp.com/icons/%@/%@.png", self.snowflake, self.iconHash];
//    NSLog(@"%@", imgURLstr);
    NSURL* imgURL = [NSURL URLWithString:imgURLstr];
    
    if(imgURL){
        NSData *data = [NSData dataWithContentsOfURL:imgURL];
        
        NSLog(@"loaded guild icon of %@", self.name);
        
        self.iconImage = [UIImage imageWithData:data];
        
        return self.iconImage;
    }else{
        return [UIImage imageNamed:@"default"];
    }
}

@end
