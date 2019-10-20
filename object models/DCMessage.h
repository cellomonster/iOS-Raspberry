//
//  DCMessage.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"
#import "DCChannel.h"
#import "DCUser.h"
#import "DCGuildMember.h"

typedef NS_ENUM(NSInteger, DCMessageType) {
	DCMessageTypeDefault,
	DCMessageTypeRecipientAddedAlert,
	DCMessageTypeRecipientRemovedAlert,
	DCMessageTypeCallNotification,
	DCMessageTypeGroupNameChangedAlert,
	DCMessageTypeGroupIconChangedAlert,
	DCMessageTypeMessagePinnedAlert,
	DCMessageTypeMemberJoinedAlert
};

@interface DCMessage : DCDiscordObject

@property DCChannel *parentChannel;
@property DCGuild *parentGuild;

@property DCUser *author;
@property DCGuildMember *member;

@property DCMessageType type;
@property NSString *content;
@property NSDate *timestamp;

@property bool mentionEveryone;
@property NSArray *mentionedUsers;
@property NSArray *mentionedRoles;

@property NSArray *attachments;
@property NSArray *embeds;

- (DCMessage *)initFromDictionary:(NSDictionary *)dict;

@end
