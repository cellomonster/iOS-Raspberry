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
@class DCMessage;

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

@property NSString *lastMessageReadOnLoginSnowflake;

@property bool isVisible;
@property bool isRead;

@property bool isCurrentlyFocused;

@property NSMutableArray* messages;

//Properties exclusive to DM channels
@property NSArray *messageRecipients;
@property NSString *messageIconHash;

- (DCChannel*)initFromDictionary:(NSDictionary *)dict andGuild:(DCGuild*)guild;

- (void)retrieveNumberOfMessages:(int)numMessages;
- (void)releaseMessages;
- (void)sendMessage:(NSString*)message;
- (void)markAsReadWithMessage:(DCMessage*)message;
- (void)handleNewMessage:(DCMessage*)message;

@end
