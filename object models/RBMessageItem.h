//
//  RBMessageItem.h
//  raspberry
//
//  Created by trevir on 11/4/19.
//  Copyright (c) 2019 Trevir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDiscordObject.h"

@class DCUser;
@class DCGuildMember;

@protocol RBMessageItem <DCDiscordObject>

@property DCUser *author;
@property NSDate *timestamp;
@property DCGuildMember *member;
@property bool writtenByUser;

@end
