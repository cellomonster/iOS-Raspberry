//
//  DCChannel.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"
@class DCGuild;

typedef NS_ENUM(NSInteger, DCChannelType) {
	DCChannelTypeGuildText,
	DCChannelTypeDirectMessage,
	DCChannelTypeGuildVoice,
	DCChannelTypeGroupMessage,
	DCChannelTypeGuildCatagory,
    DCChannelTypeGuildNews,
    DCChannelTypeGuildStore,
};

@interface DCChannel : NSObject <DCDiscordObject>

@property DCGuild *parentGuild;
@property NSString *parentCatagorySnowflake;
@property int sortingPosition;
@property NSMutableDictionary *permissionOverwrites;
@property DCChannelType channelType;

@property NSString *name;
@property NSString *topic;
@property bool isNSFW;

@property NSString *lastMessageSnowflake;

@property bool canSendMessages;
@property bool isVisible;

//Properties exclusive to DM channels
@property NSArray *messageRecipients;
@property NSString *messageIconHash;

- (DCChannel*)initFromDictionary:(NSDictionary *)dict andGuild:(DCGuild*)guild;

- (NSArray*)retrieveMessages:(int)numberOfMessages;
- (void)sendMessage:(NSString*)message;

@end
