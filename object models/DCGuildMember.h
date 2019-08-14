//
//  DCGuildMember.h
//  Disco
//
//  Created by Trevir on 3/1/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCUser.h"

typedef NS_ENUM(NSInteger, DCGuildMemberVoiceChatState) {
	DCGuildMemberVoiceChatStateOpen,
	DCGuildMemberVoiceChatStateMuted,
	DCGuildMemberVoiceChatStateDeafened,
};

@interface DCGuildMember : NSObject

@property DCUser *user;
@property NSString *nickname;
@property NSArray *roles;
@property DCGuildMemberVoiceChatState voiceChatState;

@end
