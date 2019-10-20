//
//  DCChannel.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"
#import "DCGuild.h"

typedef NS_ENUM(NSInteger, DCChannelType) {
	DCChannelTypeGuildText,
	DCChannelTypeDirectMessage,
	DCChannelTypeGuildVoice,
	DCChannelTypeGroupMessage,
	DCChannelTypeGuildCatagory,
};

@interface DCChannel : DCDiscordObject

@property DCGuild *parentGuild;
@property NSString *parentCatagorySnowflake;
@property int sortingPosition;
@property NSArray *permissionOverwrites;
@property DCChannelType channelType;

@property NSString *name;
@property NSString *topic;
@property bool isNSFW;

@property NSString *lastMessageSnowflake;

//Properties exclusive to DM channels
@property NSArray *messageRecipients;
@property NSString *messageIconHash;

- (DCChannel*)initFromDictionary:(NSDictionary *)dict;

- (NSArray*)getLastNumMessages:(int)number;

@end
