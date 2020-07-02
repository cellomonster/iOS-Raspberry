//
//  DCGuildMember.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DCGuildMemberVoiceChatState) {
	DCGuildMemberVoiceChatStateOpen,
	DCGuildMemberVoiceChatStateMuted,
	DCGuildMemberVoiceChatStateDeafened,
};

@class DCUser;
@class DCGuild;

@interface DCGuildMember : NSObject

@property DCUser *user;
@property NSString *nickname;
@property NSMutableDictionary *roles;
@property DCGuildMemberVoiceChatState voiceChatState;

- (DCGuildMember*)initFromDictionary:(NSDictionary *)dict inGuild:(DCGuild *)guild;

@end
